import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ActivatedRoute } from '@angular/router';
import { VettingService } from '@services/vetting.service';
import 'rxjs/add/operator/map';
import { SavePersonVettingVettingType_Param } from '@models/INL.VettingService.Models/save-person-vetting-vetting-type_param';
import { PersonVettingVettingType_Item } from '@models/INL.VettingService.Models/person-vetting-vetting-type_item';

@Component({
    selector: 'app-vetting-skip-courtesy',
    templateUrl: './vetting-skip-courtesy.component.html',
    styleUrls: ['./vetting-skip-courtesy.component.scss']
})
/** vetting-skip-courtesy component*/
export class VettingSkipCourtesyComponent implements OnInit {
    @Input() PersonVettingID: number;
    @Input() VettingTypeID: number;
    @Input() ReadOnly: boolean = false;

    @Output() CloseModal = new EventEmitter();

    isDataLoaded: Boolean = false;

    private route: ActivatedRoute;
    ProcessingOverlaySvc: ProcessingOverlayService;
    VettingSvc: VettingService;
    PersonsVettingVettingType: PersonVettingVettingType_Item;
    vettingTypeHeader: string;
    Message: string;
    IsSkip: Boolean = true;


    /** vetting-skip-courtesy ctor */
    constructor(route: ActivatedRoute, vettingService: VettingService, processingOverlayService: ProcessingOverlayService) {
        this.ProcessingOverlaySvc = processingOverlayService;
        this.VettingSvc = vettingService;
        this.route = route;
        this.PersonsVettingVettingType = new PersonVettingVettingType_Item();
    }
    /* ngOnInit implementation for component */
    public ngOnInit(): void {
        this.LoadPersonsVettingVettingType();
    }

    private LoadPersonsVettingVettingType(): void {
        //this.ProcessingOverlaySvc.StartProcessing("PersonVettingSkipView", "Loading Skip Vetting...");

        this.VettingSvc.GetPersonsVettingVettingType(this.PersonVettingID, this.VettingTypeID)
            .then(getPersonvettingvettingtype_Result => {
                if (getPersonvettingvettingtype_Result.item !== null) {
                    this.PersonsVettingVettingType = getPersonvettingvettingtype_Result.item;
                }
                else {
                    this.PersonsVettingVettingType = new PersonVettingVettingType_Item();
                }
                if (this.PersonsVettingVettingType.CourtesyVettingSkipped === true) {
                    this.IsSkip = false;
                }
                this.vettingTypeHeader = this.PersonsVettingVettingType.VettingTypeCode == "CON" ? "CONS" : this.PersonsVettingVettingType.VettingTypeCode;
                //this.ProcessingOverlaySvc.EndProcessing("PersonVettingSkipView");
                this.isDataLoaded = true;
            })
            .catch(error => {
                //this.ProcessingOverlaySvc.EndProcessing("PersonVettingSkipView");
                console.error('Errors in ngOnInit(): ', error);
                this.Message = 'Errors occured while loading participants.';
            });
    }

    public SaveCourtesySkip($event: any):void {
        let param = new SavePersonVettingVettingType_Param();
        this.ProcessingOverlaySvc.StartProcessing("SaveCourtesySkip", "Saving Coutesy Skip ....");
        
        param.PersonVettingID = this.PersonVettingID;
        param.VettingTypeID = this.VettingTypeID;
        param.CourtesySkippedFlag = this.PersonsVettingVettingType.CourtesyVettingSkipped;
        param.CourtesySkippedComments = this.PersonsVettingVettingType.CourtesyVettingSkippedComments;
        this.VettingSvc.SavePersonsVettingVettingType(param)
            .then(_ => {
                this.ProcessingOverlaySvc.EndProcessing("SaveCourtesySkip");
            })
            .catch(error => {
                this.ProcessingOverlaySvc.EndProcessing("SaveCourtesySkip");
                console.error('Errors in Saving Courtesy Skip Data: ', error);
            });
        this.CloseModal.emit();
    }

    public Cancel(): void {
        this.CloseModal.emit();
    }

}
