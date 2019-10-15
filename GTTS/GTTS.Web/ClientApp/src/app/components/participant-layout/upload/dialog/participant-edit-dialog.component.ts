import { Component, OnInit, Inject } from '@angular/core';
import { MatSort, MatTableDataSource, MatPaginator, MatDialog, MatDialogRef, MatFormFieldModule, MAT_DIALOG_DATA } from '@angular/material';
import { Countries_Item } from "@models/INL.ReferenceService.Models/countries_item";
import { States_Item } from "@models/INL.ReferenceService.Models/states_item";
import { GetTrainingEventParticipantsXLSX_Item } from '@models/INL.TrainingService.Models/get-training-event-participants-xlsx_item';
import { ReferenceService } from '@services/reference.service';
import { TrainingService } from '@services/training.service';
import { AuthService } from '@services/auth.service';
import { SaveTrainingEventParticipantXLSX_Param } from '@models/INL.TrainingService.Models/save-training-event-participant-xlsx_param';
import { Router } from '@angular/router';

@Component({
    selector: 'app-participant-edit-dialog',
    templateUrl: './participant-edit-dialog.component.html',
    styleUrls: ['./participant-edit-dialog.component.scss']
})

export class ParticipantEditDialogComponent implements OnInit {
    AuthSvc: AuthService;
    RefService: ReferenceService;
    TrainingService: TrainingService;
    Countries: Countries_Item[];
    States: States_Item[];
    Participant: GetTrainingEventParticipantsXLSX_Item;
    DialogRef: MatDialogRef<ParticipantEditDialogComponent>;

    constructor(authSvc: AuthService, refService: ReferenceService, trainingService: TrainingService, dialogRef: MatDialogRef<ParticipantEditDialogComponent>, @Inject(MAT_DIALOG_DATA) participant: GetTrainingEventParticipantsXLSX_Item) {
        this.AuthSvc = authSvc;
        this.RefService = refService;
        this.TrainingService = trainingService;
        this.Participant = participant;
        this.DialogRef = dialogRef;
    }

    onCancelClick(): void {
        this.DialogRef.close('Cancel');
    }
    onConfirmClick(): void {
        this.DialogRef.close('Confirm');
    }

    public onOkClick() {
        this.UpdateParticipantXLSX();
        this.DialogRef.close();
    }

    ngOnInit(): void {

        const countryIDFilter = this.AuthSvc.GetUserProfile().CountryID;
        const postIDFilter = this.AuthSvc.GetUserProfile().CountryID;

        if (sessionStorage.getItem('Countries') == null
            || sessionStorage.getItem('States') == null) {
            this.RefService.GetTrainingEventReferences_Deprecated(countryIDFilter, postIDFilter)
                .then(result => {
                    sessionStorage.setItem('States-' + countryIDFilter, JSON.stringify(result.ReferenceTables.States));
                    sessionStorage.setItem('Countries', JSON.stringify(result.ReferenceTables.Countries));
                    this.Countries = JSON.parse(sessionStorage.getItem('Countries'));
                    this.States = JSON.parse(sessionStorage.getItem('States')); 
                })
                .catch(error => {
                    console.error('Errors in ngOnInit(): ', error);
                });
        }
        else {
            this.Countries = JSON.parse(sessionStorage.getItem('Countries'));
            this.States = JSON.parse(sessionStorage.getItem('States'));
        }
    }

    UpdateParticipantXLSX(): void {
        var param = new SaveTrainingEventParticipantXLSX_Param();
        Object.assign(param, this.Participant);

        this.TrainingService.UpdateTrainingEventParticipantXLSX(this.Participant.TrainingEventID, param)
            .then(participantXLSX => {
                this.TrainingService.PreviewTrainingEventParticipants(this.Participant.TrainingEventID);
            })
            .catch(error => {
                console.error('Errors in UpdateParticipantXLSX() while updating: ', error);
            });
    }
}

