import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';
import { ParticipantsUploadRowError } from './participants-upload-row-error';

@Component({
    selector: 'app-participants-upload-error',
    templateUrl: './participants-upload-error.component.html',
    styleUrls: ['./participants-upload-error.component.scss']
})

export class ParticipantsUploadErrorComponent {
    dialogRef: MatDialogRef<ParticipantsUploadErrorComponent>;
    rowErrors: ParticipantsUploadRowError[] = [];

    constructor(dialogRef: MatDialogRef<ParticipantsUploadErrorComponent>, @Inject(MAT_DIALOG_DATA) dialogData) {
        this.dialogRef = dialogRef;
        this.rowErrors = dialogData.RowErrors;
    }

    public OnOkClick() {
        this.dialogRef.close('Ok');
    }

    OnCancelClick(): void {
        this.dialogRef.close('Cancel');
    }


}
