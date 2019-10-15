import { Component, OnInit, Inject } from '@angular/core';
import { GetTrainingEventBatchParticipants_Item } from '@models/INL.TrainingService.Models/get-training-event-batch-participants_item';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';

@Component({
    selector: 'app-participants-in-vetting-warning',
    templateUrl: './participants-in-vetting-warning.component.html',
    styleUrls: ['./participants-in-vetting-warning.component.scss']
})

export class ParticipantsInVettingWarningComponent implements OnInit {
    Participants: GetTrainingEventBatchParticipants_Item[];
    dialogRef: MatDialogRef<ParticipantsInVettingWarningComponent>;

    constructor(dialogRef: MatDialogRef<ParticipantsInVettingWarningComponent>, @Inject(MAT_DIALOG_DATA) dialogData) {
        this.dialogRef = dialogRef;;
        this.Participants = dialogData.participantsInVetting;
    }

    ngOnInit(): void {

    }

    OnCancelClick(): void {
        this.dialogRef.close('Cancel');
    }

    public OnOkClick() {
        this.dialogRef.close('Ok');
    }
}
