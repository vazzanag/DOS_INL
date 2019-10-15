import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { MessageDialogModel } from './message-dialog-model';
import { MessageDialogType } from './message-dialog-type';
import { MessageDialogResult } from './message-diaog-result';

@Component({
    selector: 'app-message-dialog',
    templateUrl: './message-dialog.component.html',
    styleUrls: ['./message-dialog.component.css']
})
export class MessageDialogComponent implements OnInit {

    public type = MessageDialogType;
    public model: MessageDialogModel;
    private dialogRef: MatDialogRef<MessageDialogComponent>;

    constructor(@Inject(MAT_DIALOG_DATA) model: MessageDialogModel, dialogRef: MatDialogRef<MessageDialogComponent>) {
        this.model = model;
        this.dialogRef = dialogRef;
    }

    ngOnInit() {
    }

    public onPositiveClick() {
        this.dialogRef.close(MessageDialogResult.Positive);
    }

    public onNeutralClick() {
        this.dialogRef.close(MessageDialogResult.Neutral);
    }

    public onNegativeClick() {
        this.dialogRef.close(MessageDialogResult.Negative);
    }
}
