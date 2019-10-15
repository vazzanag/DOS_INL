import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ActivatedRoute } from '@angular/router';
import { VettingService } from '@services/vetting.service';
import { ReferenceService } from '@services/reference.service';
import { HitViolationType_Item } from '@models/INL.ReferenceService.Models/hit-violation-type_item';
import { LeahyHitAppliesTo } from '@models/INL.ReferenceService.Models/leahy-hit-applies-to';
import { LeahyHitResult_Item } from '@models/INL.ReferenceService.Models/leahy-hit-result_item';
import { GetPersonsLeahyVetting_Item } from '@models/INL.VettingService.Models/get-persons-leahy-vetting_item';
import { SaveLeahyVettingHit_Param } from '@models/INL.VettingService.Models/save-leahy-vetting-hit_param';
import { ToastService } from '@services/toast.service';

@Component({
    selector: 'app-leahy-vetting-form',
    templateUrl: './leahy-vetting-form.component.html',
    styleUrls: ['./leahy-vetting-form.component.scss']
})
/** leahy-vetting-form component*/
export class LeahyVettingFormComponent implements OnInit {
    @Input() PersonVettingID: number;
    @Input() DOB: Date;
    @Input() PersonName: string;
    @Input() ReadOnly: boolean = false;
    @Input() ReadOnlyNotes: boolean = false;
    @Output() CloseModal = new EventEmitter();
    @Output() SaveModal = new EventEmitter<any>();
    private route: ActivatedRoute;
    processingOverlayService: ProcessingOverlayService;
    vettingService: VettingService;
    referenceService: ReferenceService;
    hitViolationTypes: HitViolationType_Item[];
    leahyHitResults: LeahyHitResult_Item[];
    leahyHitAppliesTo: LeahyHitAppliesTo[];
    model: GetPersonsLeahyVetting_Item;
    dataLoaded: boolean = false;
    ToastSvc: ToastService;


    /** leahy-vetting-form ctor */
    constructor(route: ActivatedRoute, vettingService: VettingService, processingOverlayService: ProcessingOverlayService, referenceService: ReferenceService, toastService: ToastService, ) {
        this.processingOverlayService = processingOverlayService;
        this.vettingService = vettingService;
        this.route = route;
        this.referenceService = referenceService;
        this.ToastSvc = toastService;
    }

    public ngOnInit(): void {
        this.LoadReferences().then(_ => {
            this.LoadPersonsLeahyVetting();
        });
    }


    private LoadReferences(): Promise<boolean> {

        return new Promise(resolve => {
            if (sessionStorage.getItem('HitCredibilityLevels') == null
                || sessionStorage.getItem('LeahyHitAppliesTo') == null
                || sessionStorage.getItem('LeahyHitResult_Item') == null) {
                this.referenceService.GetLeahyVettingHitReferences()
                    .then(result => {
                        for (let table of result.Collection) {
                            if (null != table) {
                                sessionStorage.setItem(table.Reference, table.ReferenceData);
                            }
                        }
                        this.leahyHitResults = JSON.parse(sessionStorage.getItem('LeahyHitResults'));
                        this.leahyHitAppliesTo = JSON.parse(sessionStorage.getItem('LeahyHitAppliesTo'));
                        this.hitViolationTypes = JSON.parse(sessionStorage.getItem('HitViolationTypes'));
                        resolve(true);
                    })
                    .catch(error => {
                        console.error('Errors occured while loading reference data for vetting hit form', error);
                        resolve(false);
                    });
            }
            else {
                this.leahyHitResults = JSON.parse(sessionStorage.getItem('LeahyHitResults'));
                this.leahyHitAppliesTo = JSON.parse(sessionStorage.getItem('LeahyHitAppliesTo'));
                this.hitViolationTypes = JSON.parse(sessionStorage.getItem('HitViolationTypes'));
                resolve(true);
            }
        });
    }

    private LoadPersonsLeahyVetting() {
        this.processingOverlayService.StartProcessing("LoadLeahyHit", "Loading Data..");
        this.vettingService.GetPersonsLeahyVettingHit(this.PersonVettingID)
            .then(result => {
                if (result.item == undefined || result.item == null) {
                    this.model = new GetPersonsLeahyVetting_Item();
                    this.model.PersonsVettingID = this.PersonVettingID;
                }
                else
                    this.model = result.item;
                this.dataLoaded = true;
                this.processingOverlayService.EndProcessing("LoadLeahyHit");
            })
            .catch(error => {
                console.error('Errors occurred while loading leahy vetting hits', error);
                this.processingOverlayService.EndProcessing("LoadLeahyHit");
                this.CloseModal.emit();
            });
    }

    public Cancel(): void {
        this.CloseModal.emit();
    }


    /** Save button "Click" event handler */
    public SaveLeahyHit() {
        let param = this.MapToSaveParam();
        this.processingOverlayService.StartProcessing("SaveLeahyHit", "Saving Data..");
        this.vettingService.SaveLeahyVettingHit(param)
            .then(result => {
                this.model.LeahyVettingHitID = result.item.LeahyVettingHitID;
                this.processingOverlayService.EndProcessing("SaveLeahyHit");
                this.ToastSvc.sendMessage('Leahy hit saved successfully.', 'toastSuccess');
                this.SaveModal.emit();
            })
            .catch(error => {
                console.error('Errors occurred while saving vetting hits', error);
                this.processingOverlayService.EndProcessing("SaveLeahyHit");
                this.ToastSvc.sendMessage('Errors occurred while saving leahy vetting hits.', 'toastError');
            });
    }

    private MapToSaveParam(): SaveLeahyVettingHit_Param {
        let param: SaveLeahyVettingHit_Param = new SaveLeahyVettingHit_Param();
        param.PersonsVettingID = this.model.PersonsVettingID;
        param.LeahyHitAppliesToID = this.model.LeahyHitAppliesToID;
        param.LeahyHitResultID = this.model.LeahyHitResultID;
        param.ViolationTypeID = this.model.ViolationTypeID;
        param.Summary = this.model.Summary;
        param.LeahyVettingHitID = this.model.LeahyVettingHitID;
        return param;
    }
}
