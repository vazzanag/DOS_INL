import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import * as moment from 'moment';
import { MigrateTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/migrate-training-event-participants_param';
import { RemoveTrainingEventStudents_Param } from '@models/INL.TrainingService.Models/remove-training-event-students_param';
import { UpdateTrainingEventStudentsParticipantFlag_Param } from '@models/INL.TrainingService.Models/update-training-event-students-participant-flag_param';
import { AuthService } from '@services/auth.service';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ReferenceService } from '@services/reference.service';
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { RemoveTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/remove-training-event-participants_param';
import { ItemModel } from './item-model';
import { UpdateTypeTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/update-type-training-event-participants_param';



@Component({
    selector: 'app-person-status-form',
    templateUrl: './person-status-form.component.html',
    styleUrls: ['./person-status-form.component.scss']
})
/** person-remove-form component*/
export class PersonStatusFormComponent implements OnInit {

    @Output() CloseModal = new EventEmitter();
    @Input() TrainingEventID: number;
    @Input() Participants: TrainingEventParticipant[] = [];
    public itemModels: ItemModel[] = [];
    @Input() UpdateType: UpdateType = UpdateType.BulkUpdate;

    /* TODO: Need the RemovalReasonID and RemovalCauseID when the Person removal is reopened to see te removal reason or edit if edit of the reasons is needed */

    public AuthSvc: AuthService;
    ReferenceSvc: ReferenceService;
    ProcessingOverlaySvc: ProcessingOverlayService
    ToastSvc: ToastService;
    TrainingSvc: TrainingService;

    RemovalReasons: any;
    RemovalCauses: any;
    RemovalCausesFiltered: any;

    RemovalReasonID?: number = -1;
    RemovalCauseID?: number = -1;
    CancellationDate?: Date = new Date();

    ModalLabel: string = 'Status Update';
    BulkMode: boolean = false;
    Status: string = '';

    DisplayRemovalReason: boolean = false;
    DisplayRemovalCauses: boolean = false;
    DisplayCancellationDate: boolean = false;
    RemovalCauseText: string;
    public get personIds(): number[] {
        return this.itemModels
            .filter(m => m.selected)
            .map(m => m.item.PersonID);
    }
    public get evenRemovalReasons(): any {
        return this.RemovalReasons.filter(r => r.RemovalReasonID % 2 == 0);
    }
    public get oddRemovalReasons(): any {
        return this.RemovalReasons.filter(r => r.RemovalReasonID % 2 != 0);
    }
    public get allModelsSelected(): boolean {
        return this.itemModels.filter(m => m.selected).length == this.itemModels.length;
    }
    ValidForm: boolean;

    /** person-remove-form ctor */
    constructor(authSvc: AuthService, referenceSvc: ReferenceService, processingOverlaySvc: ProcessingOverlayService, toastSvc: ToastService, trainingSvc: TrainingService) {
        this.AuthSvc = authSvc;
        this.ReferenceSvc = referenceSvc;
        this.ProcessingOverlaySvc = processingOverlaySvc;
        this.ToastSvc = toastSvc;
        this.TrainingSvc = trainingSvc;
    }

    public ngOnInit(): void {
        this.LoadReferences();
        this.itemModels = this.Participants.map(p => {
            let model = new ItemModel();
            model.item = p;
            return model;
        });

        // Sort the participants equal that the participant view
        let a = this.itemModels.filter(a => a.item.ParticipantType == 'Instructor');
        let b = this.itemModels.filter(a => a.item.ParticipantType == 'Student');
        let c = this.itemModels.filter(a => a.item.ParticipantType == 'Alternate');
        let d = this.itemModels.filter(a => a.item.ParticipantType == 'Removed');
        this.itemModels = [];
        this.itemModels = a.concat(b).concat(c).concat(d);

        if (this.UpdateType == UpdateType.BulkUpdate) {
            //BulkStatusChange -> display Radios to change between Participant Alternate Remove
            this.ModalLabel = 'Update participant status';
            this.BulkMode = true;
        }
        else if (this.UpdateType == UpdateType.Remove) {
            //Single mode -> hide Radios of Participant Alternate Remove-> Set mode = Remove
            this.ModalLabel = `Remove: ${this.Participants[0].FirstMiddleNames} ${this.Participants[0].LastNames} ${moment(this.Participants[0].DOB).format('MM/DD/YYYY')}`;
            this.Status = 'removed';
            this.DisplayRemovalReason = true;
            this.CancellationDate = (this.Participants[0].DateCanceled) ? new Date(this.Participants[0].DateCanceled) : new Date();
            if (this.Participants[0].PersonID != null && this.Participants[0].PersonID > 0) {
                this.personIds.push(this.Participants[0].PersonID);
            }
        }
    }

    /* Load reference data Removal Reasons, Removal Cause */
    private LoadReferences(): void {
        const countryIdFilter = this.AuthSvc.GetUserProfile().CountryID;

        if (sessionStorage.getItem('RemovalReasons') == null
            || sessionStorage.getItem('RemovalCauses') == null) {
            this.ProcessingOverlaySvc.StartProcessing("PersonRemoveForm", "Loading Lookup Data...");

            this.TrainingSvc.GetParticipantRemovalCauses().then(result => {
                this.RemovalCauses = result.Items;
                sessionStorage.setItem('RemovalCauses', JSON.stringify(result.Items, null, '\t'));
            }).catch(error => {
                this.ProcessingOverlaySvc.EndProcessing("PersonRemoveForm");
                console.error('Errors in LoadReferences() GetParticipantRemovalCauses: ', error);
            });

            this.TrainingSvc.GetParticipantRemovalReasons().then(result => {                
                this.RemovalReasons = result.Items;
                sessionStorage.setItem('RemovalReasons', JSON.stringify(result.Items, null, '\t'));
            }).catch(error => {
                this.ProcessingOverlaySvc.EndProcessing("PersonRemoveForm");
                console.error('Errors in LoadReferences() GetParticipantRemovalReasons: ', error);
            });

            this.ProcessingOverlaySvc.EndProcessing("PersonRemoveForm");

        }
        else {
            this.RemovalReasons = JSON.parse(sessionStorage.getItem('RemovalReasons'));
            this.RemovalCauses = JSON.parse(sessionStorage.getItem('RemovalCauses'));
        }
    }

    /* Add behaviour to when certain value of dropdown is selected to filter, hide or display second dropdown and Cancel date field */
    public SetRemovalReason(reason: any): void {
        if (this.RemovalReasonID != reason.RemovalReasonID) {
            this.RemovalReasonID = reason.RemovalReasonID;
            this.RemovalCausesFiltered = this.RemovalCauses.filter(function (element, index, array) {
                return (element.RemovalReasonID == reason.RemovalReasonID);
            });
            this.DisplayRemovalCauses = (this.RemovalCausesFiltered.length > 0);
            this.DisplayCancellationDate = (reason.Description == 'Cancellation');
            /* Check if the previously selected removal cause description matches with one of the filtered causes and select it, otherwise reset to -1 */
            var causeAux = this.RemovalCausesFiltered.find(item => item.Description === this.RemovalCauseText);
            if (causeAux != undefined) {
                this.RemovalCauseID = causeAux.RemovalCauseID;
            }
            else {
                this.RemovalCauseID = -1;
            }
        }
    }

    public SetRemovalCause(cause: any): void {
        this.RemovalCauseID = cause.RemovalCauseID;
        this.RemovalCauseText = cause.Description;
    }

    public SetStatusUpdate(status: string): void {
        this.Status = status;
        this.DisplayRemovalReason = (status == 'removed');
    }

    public IsInvalidForm(): boolean {
        return ((this.BulkMode && (this.Status == '' || this.personIds.length == 0))
            || (this.DisplayRemovalReason && (this.RemovalReasonID < 0)));
    }

    /* Remove the person from the event */
    public Save(): void {
        this.Update();
    }

	private Remove(): void {
		this.ProcessingOverlaySvc.StartProcessing("ParticipantRemoveForm", "Removing...");

        /* Nex block is used for removal */
        var param = new RemoveTrainingEventParticipants_Param();
        param.TrainingEventID = this.TrainingEventID;
        param.PersonIDs = this.personIds;
        param.RemovalReasonID = this.RemovalReasonID;
        param.RemovalCauseID = (this.RemovalCauseID > 0) ? this.RemovalCauseID : null;
        param.DateCanceled = (this.DisplayCancellationDate) ? this.CancellationDate : null;

        this.TrainingSvc.RemoveTrainingEventParticipants(param)
            .then(result => {
                this.ToastSvc.sendMessage('Participant removed successfully', 'toastSuccess');
                this.ProcessingOverlaySvc.EndProcessing("ParticipantRemoveForm");
                this.CloseModal.emit(true);
            })
            .catch(error => {
                console.error(error);
                this.ToastSvc.sendMessage('Errors occurred while removing participant', 'toastError');
                this.ProcessingOverlaySvc.EndProcessing("ParticipantRemoveForm");
            });
    }

    private async Update() {
        this.ProcessingOverlaySvc.StartProcessing("ParticipantUpdateForm", "Updating...");

        try {
            let params = new UpdateTypeTrainingEventParticipants_Param();
            params.TrainingEventID = this.TrainingEventID;
            params.PersonIDs = this.personIds;
            params.RemovalReasonID = (this.RemovalReasonID > 0) ? this.RemovalReasonID : null;
            params.RemovalCauseID = (this.RemovalCauseID > 0) ? this.RemovalCauseID : null;
            switch (this.Status) {
                case "participant":
                    params.TrainingEventParticipantTypeID = 1;
                    break;
                case "instructor":
                    params.TrainingEventParticipantTypeID = 2;
                    break;
                case "alternate":
                    params.TrainingEventParticipantTypeID = 3;
                    break;
                case "removed":
                    params.TrainingEventParticipantTypeID = 4;
                    break;
                default:
                    params.TrainingEventParticipantTypeID = 1;
                    break;
            }

            await this.TrainingSvc.UpdateTypeTrainingEventParticipants(params);

            this.ToastSvc.sendMessage('Participants saved successfully', 'toastSuccess');
            this.ProcessingOverlaySvc.EndProcessing("ParticipantUpdateForm");
            this.CloseModal.emit(true);
        } catch (error) {
            console.error(error);
            this.ToastSvc.sendMessage('Errors occurred while saving participants', 'toastError');
            this.ProcessingOverlaySvc.EndProcessing("ParticipantUpdateForm");
        }
    }

    private migrateParticipants(toInstructor: boolean, isParticipant: boolean = false): Promise<any> {
        let params = new MigrateTrainingEventParticipants_Param();
        params.TrainingEventID = this.TrainingEventID;
        params.PersonIDs = this.personIds;
        params.ToInstructor = toInstructor;
        params.IsParticipant = isParticipant;
        return this.TrainingSvc.MigrateTrainingEventParticipants(params);
    }

    /* Close modal window */
    public Cancel(): void {
        this.CloseModal.emit(false);
    }

    public onSelectAllToggleClick() {
        let newValue = !this.allModelsSelected;
        this.itemModels.forEach(m => {
            m.selected = newValue;
        });
}

}

export enum UpdateType {
    BulkUpdate,
    Remove
}
