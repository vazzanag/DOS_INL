import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { ReferenceService } from '@services/reference.service';
import { AuthorizingLaw_Item } from '@models/INL.ReferenceService.Models/authorizing-law_item';
import { FundingSources_Item } from '@models/INL.ReferenceService.Models/funding-sources_item';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { VettingFundFormModel } from './vetting-funding-form-model';
import { NgForm } from '@angular/forms';
import { VettingService } from '@services/vetting.service';

@Component({
    selector: 'app-vetting-funding-form',
    templateUrl: './vetting-funding-form.component.html',
    styleUrls: ['./vetting-funding-form.component.scss']
})
/** vetting-funding-form component*/
export class VettingFundingFormComponent implements OnInit {
    @Input() TrainingEventID: number;
    @Input() TrainingEventStartDate: Date;
    @Input() BatchSubmissionDate: Date;
    @Input() AuthorizingLawID: number;
    @Input() FundingSourceID: number;
    @Input() ShowLeahyDate: boolean;
    @Input() ShowCourtesyDate: boolean;
    @Input() LeahyLeadTime: number;
    @Input() CourtesyLeadTime: number;

    @Output() SaveFundingEvent = new EventEmitter<any>();
    @Output() CloseModal = new EventEmitter();

    ProcessingOverlaySvc: ProcessingOverlayService;
    FundingSourceDataSource: FundingSources_Item[] = [];
    AuthorizingLawDataSource: AuthorizingLaw_Item[] = [];
    model: VettingFundFormModel;
    AuthSvc: AuthService;
    ReferenceSvc: ReferenceService;
    VettingSvc: VettingService;
    dataLoaded: boolean = false;
    showLeahyDateError: boolean = false;
    showCourtesyDateError: boolean = false;
    showCourtesyAfterDateError: boolean = false;
    showLeahyAfterDateError: boolean = false;

    minDate: Date = new Date();

    /** vetting-funding-form ctor */
    constructor(authService: AuthService, referenceService: ReferenceService, processingOverlayService: ProcessingOverlayService
    , vettingService: VettingService) {
        this.AuthSvc = authService;
        this.ReferenceSvc = referenceService;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.VettingSvc = vettingService;
    }

    public ngOnInit() {
        this.LoadLookups();
    }

    public LeahyNeedByDateChanged(event: any) {
        this.showLeahyDateError = false;
        this.showLeahyAfterDateError = false;
        if (this.model.LeahyNeedByDate > this.TrainingEventStartDate)
            this.showLeahyAfterDateError = true;
        else
            if (this.CalculateWeekDays(this.BatchSubmissionDate, this.model.LeahyNeedByDate) < this.LeahyLeadTime)
                this.showLeahyDateError = true;
               
    }

    public CourtesyNeedByDateChanged(event: any) {
        this.showCourtesyDateError = false;
        this.showCourtesyAfterDateError = false;
        if (this.model.CourtesyNeedByDate > this.TrainingEventStartDate)
            this.showCourtesyAfterDateError = true; 
        else
            if (this.CalculateWeekDays(this.BatchSubmissionDate, this.model.CourtesyNeedByDate) < this.CourtesyLeadTime)
                this.showCourtesyDateError = true;                           
    }


    public SaveFunding(form: NgForm) {
        this.SaveFundingEvent.emit({ event: event, fundingmodel: this.model });
    }

    public CancelClick() {
        this.CloseModal.emit();
    }

    // Load Lookup Data
    private LoadLookups(): void {
        this.model = new VettingFundFormModel();
        this.model.AuthorizingLawID = this.AuthorizingLawID;
        this.model.FundingSourceID = this.FundingSourceID;

        // Get lookup data from session
        this.FundingSourceDataSource = JSON.parse(sessionStorage.getItem('FundingSources'));
        this.AuthorizingLawDataSource = JSON.parse(sessionStorage.getItem('AuthorizingLaw'));

        this.ProcessingOverlaySvc.StartProcessing("LoadLookUp", "Loading lookup...");
        // If session data was empty, call azure function
        if (null == this.FundingSourceDataSource || null == this.AuthorizingLawDataSource
            || this.FundingSourceDataSource.length == 0 || this.AuthorizingLawDataSource.length == 0) {
            const countryIDFilter = this.AuthSvc.GetUserProfile().CountryID;
            const postID = this.AuthSvc.GetUserProfile().PostID;

            this.ReferenceSvc.GetVettingPreviewReferences(countryIDFilter, postID)
                .then(result => {
                    for (let table of result.Collection) {
                        if (null != table) {
                            sessionStorage.setItem(table.Reference, table.ReferenceData);
                        }
                    }

                    this.FundingSourceDataSource = JSON.parse(sessionStorage.getItem('FundingSources'));
                    this.FundingSourceDataSource.forEach(function (item) {
                        item.CodeDescription = item.Code + " - " + item.Description;
                    });
                    this.AuthorizingLawDataSource = JSON.parse(sessionStorage.getItem('AuthorizingLaw'));
                    this.dataLoaded = true;
                    // Get values to prefill the form.
                    this.GetPreviousBatches();

                    this.ProcessingOverlaySvc.EndProcessing("LoadLookUp");
                })
                .catch(error => {
                    console.error('Errors in ngOnInit(): ', error);
                    this.ProcessingOverlaySvc.EndProcessing("LoadLookUp");
                });
        }
        else {
            this.FundingSourceDataSource = JSON.parse(sessionStorage.getItem('FundingSources'));
            this.FundingSourceDataSource.forEach(function (item) {
                item.CodeDescription = item.Code + " - " + item.Description;
            });
            this.AuthorizingLawDataSource = JSON.parse(sessionStorage.getItem('AuthorizingLaw'));
            this.dataLoaded = true;
            // Get values to prefill the form.
            this.GetPreviousBatches();

            this.ProcessingOverlaySvc.EndProcessing("LoadLookUp");            
        }
    }

    // Calculates the number of weekdays between 2 dates
    private CalculateWeekDays(StartDate: Date, EndDate: Date): number {
        let iterationDate = new Date(StartDate);
        let numberOfDays = 0;

        while (iterationDate.valueOf() <= EndDate.valueOf()) {
            if (iterationDate.getDay() > 0 && iterationDate.getDay() < 6)
                numberOfDays++;
            iterationDate.setDate(iterationDate.getDate() + 1);
        }

        return numberOfDays;
    }

    private GetPreviousBatches(): void {
        this.VettingSvc.GetVettingBatchesByTrainingEventID(Number(this.TrainingEventID))
            .then(result => {
                let foundError: boolean = false;
                if (null != result.ErrorMessages && result.ErrorMessages.length > 0) {
                    foundError = true;
                    result.ErrorMessages.forEach(message => {
                        console.error('Submit batch for vetting error', message);
                    });
                }
                else {
                    if (result.Batches.length > 0) {
                        result.Batches = result.Batches.sort(function (a, b) {
                            return b.VettingBatchID - a.VettingBatchID
                        });                        

                        this.model.AuthorizingLawID = result.Batches[0].AuthorizingLawID;                        
                        this.model.FundingSourceID = result.Batches[0].VettingFundingSourceID;

                        let batchesCourtesy = result.Batches.filter(batch => batch.VettingBatchTypeID == 1); // 1 = Courtesy
                        let batchesLeahy = result.Batches.filter(batch => batch.VettingBatchTypeID == 2); // 2 = Leahy

                        if (batchesCourtesy.length > 0) {
                            const dCourtesyAux: Date = new Date(batchesCourtesy[0].DateVettingResultsNeededBy);
                            this.model.CourtesyNeedByDate = dCourtesyAux;

                            this.CourtesyNeedByDateChanged(null);
                        }
                        if (batchesLeahy.length > 0) {
                            const dLeahyAux: Date = new Date(batchesLeahy[0].DateVettingResultsNeededBy);
                            this.model.LeahyNeedByDate = dLeahyAux;

                            this.LeahyNeedByDateChanged(null);
                        }
                    }
                }
            })
            .catch(error => {
                console.log('Errors loading batch data: ', error);
            });
    }
}
