import { Component, OnInit, EventEmitter, Output, Input } from '@angular/core';
import { TrainingService } from '@services/training.service';
import { PersonRemoveItem } from '@models/person-remove-item';
import { RemovalCauses_Item } from '@models/INL.ReferenceService.Models/removal-causes_item';
import { RemovalReasons_Item } from '@models/INL.ReferenceService.Models/removal-reasons_item';
import { ReferenceService } from '@services/reference.service';
import { RemoveTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/remove-training-event-participants_param';
import { ToastService } from '@services/toast.service';

@Component({
    selector: 'app-participant-removal',
    templateUrl: './participant-removal.component.html',
    styleUrls: ['./participant-removal.component.scss']
})
/** ParticipantRemoval component*/
export class ParticipantRemovalComponent implements OnInit
{
    @Output() CloseModal: EventEmitter<boolean> = new EventEmitter();
    @Input() TrainingEventID: number;
    @Input() PersonID: number;

    removalCauses: RemovalCauses_Item[];
    removalReasons: RemovalReasons_Item[];
    removalReasonsRight: RemovalReasons_Item[];
    removalReasonsLeft: RemovalReasons_Item[];
    removalCausesForList: RemovalCauses_Item[];
    participant: PersonRemoveItem;
    trainingService: TrainingService;
    referenceService: ReferenceService;
    toastService: ToastService
    isLoading: boolean;
    isSaving: boolean;

    removalReasonID: number;
    removalCauseID: number;

    /** ParticipantRemoval ctor */
    constructor(trainingService: TrainingService, referenceService: ReferenceService, toastService: ToastService)
    {
        this.trainingService = trainingService;
        this.referenceService = referenceService;
        this.toastService = toastService;
        this.participant = new PersonRemoveItem();
        this.isLoading = true;
        this.isSaving = false;
        this.removalReasonID = -1;
        this.removalCauseID = -1;

        this.removalCauses = [];
        this.removalReasons = [];
        this.removalReasonsRight = [];
        this.removalReasonsLeft = [];
        this.removalCausesForList = [];
    }

    /* ParticipantRemovalComponent OnInit implementation */
    public ngOnInit(): void
    {
        this.LoadReferences();
    }

    /* Loads reference data needed by the component */
    public LoadReferences(): void
    {
        // Get lookup data from session
        this.removalCauses = JSON.parse(sessionStorage.getItem('RemovalCauses'));
        this.removalReasons = JSON.parse(sessionStorage.getItem('RemovalReasons'));

        // If session data was empty, call function
        if (null == this.removalCauses || null == this.removalReasons
            || this.removalCauses.length == 0 || this.removalReasons.length == 0)
        {
            this.referenceService.GetParticipantRemovalReferences()
                .then(result =>
                {
                    for (let table of result.Collection)
                    {
                        if (null != table)
                        {
                            sessionStorage.setItem(table.Reference, table.ReferenceData);
                        }
                    }

                    this.removalCauses = JSON.parse(sessionStorage.getItem('RemovalCauses'));
                    this.removalReasons = JSON.parse(sessionStorage.getItem('RemovalReasons'));

                    if (this.removalReasons)
                    {
                        for (let i = 0; i < this.removalReasons.length; i++)
                        {
                            if (i % 2 == 0)
                                this.removalReasonsLeft.push(this.removalReasons[i]);
                            else
                                this.removalReasonsRight.push(this.removalReasons[i]);
                        }
                    }

                    this.isLoading = false;
                })
                .catch(error =>
                {
                    console.error('Errors in GetTrainingEventCloseoutReferences: ', error);
                    this.isLoading = false;
                });
        }
        else
        {
            for (let i = 0; i < this.removalReasons.length; i++)
            {
                if (i % 2 == 0)
                    this.removalReasonsLeft.push(this.removalReasons[i]);
                else
                    this.removalReasonsRight.push(this.removalReasons[i]);
            }

            this.isLoading = false;
        }
    }

    /* RemoveParticipant "click" event handler */
    public SaveRemove(): void
    {
        this.isSaving = true;
        let param: RemoveTrainingEventParticipants_Param = new RemoveTrainingEventParticipants_Param();

        param.TrainingEventID = this.TrainingEventID;
        param.PersonIDs = [this.PersonID];
        param.RemovalReasonID = this.removalReasonID;
        if (this.removalCauseID > -1)
            param.RemovalCauseID = this.removalCauseID;

        this.trainingService.RemoveTrainingEventParticipants(param)
            .then(_ =>
            {
                this.isSaving = false;
                this.CloseModal.emit(true);
            })
            .catch(error =>
            {
                this.toastService.sendMessage('Errors occurred while removing participant', 'toastError');
                console.error('Errors occurred while remove participant', error);
                this.isSaving = false;
            });
    }

    /* Removal Reason button group "Change" event handler */
    public RemovalReasons_Change(reasonID: number): void
    {
        this.removalCauseID = -1;
        this.removalReasonID = reasonID;
        this.removalCausesForList = this.removalCauses.filter(c => c.RemovalReasonID == reasonID);
    }

    /* Removal Cause button group "Change" event handler */
    public RemovalCauses_Change(causeID: number): void
    {
        this.removalCauseID = causeID;
    }

    /* Cancel button "Click" event handler */
    public Cancel(): void
    {
        // Go back to previous page
        this.CloseModal.emit(false);
    }
}
