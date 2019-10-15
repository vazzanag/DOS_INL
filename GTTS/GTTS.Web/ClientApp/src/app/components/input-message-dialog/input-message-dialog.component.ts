import { Component, Inject, OnInit, ViewChild, ElementRef } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { InputModel } from './input-model';

@Component({
    selector: 'app-input-message-dialog',
    templateUrl: './input-message-dialog.component.html',
    styleUrls: ['./input-message-dialog.component.css']
})
export class InputMessageDialogComponent implements OnInit {

    public inputValue: string;
    public inputModel: InputModel;
    private dialogRef: MatDialogRef<InputMessageDialogComponent>;

    constructor(@Inject(MAT_DIALOG_DATA) inputModel: InputModel, dialogRef: MatDialogRef<InputMessageDialogComponent>) {
        this.inputModel = inputModel;
        this.inputValue = inputModel.inputValue;
        this.dialogRef = dialogRef;
    }

    ngOnInit() {
    }

    @ViewChild('inputVal') inputEl: ElementRef;

    ngAfterViewInit() {
        this.inputEl.nativeElement.focus();
    }

    public onPositiveClick() {
        this.dialogRef.close(this.inputValue);
    }

    public onNegativeClick() {
        this.dialogRef.close();
    }
}
