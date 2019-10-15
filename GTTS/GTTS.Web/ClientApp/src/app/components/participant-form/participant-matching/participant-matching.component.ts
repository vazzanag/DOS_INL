import { Component, OnInit, Inject, DoCheck, ViewChild } from '@angular/core';
import { MAT_DIALOG_DATA, MatTableDataSource, MatTable, MatSort, MatDialogRef } from '@angular/material';
import { SaveTrainingEventPersonParticipant_Param } from '@models/INL.TrainingService.Models/save-training-event-person-participant_param';
import { ToastService } from '@services/toast.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { TrainingService } from '@services/training.service';
import { MatchingPerson_Item } from '@models/MatchingPerson_Item';
import { GetTrainingEventParticipant_Item } from '@models/INL.TrainingService.Models/get-training-event-participant_item';

@Component({
    selector: 'app-participant-matching',
    templateUrl: './participant-matching.component.html',
    styleUrls: ['./participant-matching.component.scss']
})
/** participant-matching component*/
export class ParticipantMatchingComponent implements OnInit {

    Message: string;
    @ViewChild(MatTable) ParticipantTable: MatTable<any>;
    @ViewChild(MatSort) Sort: MatSort;
    selectedMatchingPersonID: number;
    matchingPersons: MatchingPerson_Item[] = [];
    showContinueButton: boolean = false;
    warningMessage: string = '';
    DisplayedColumns: string[];
    DataSource: MatTableDataSource<any>;
    dialogRef: MatDialogRef<ParticipantMatchingComponent>;
    trainingEventParticipants: GetTrainingEventParticipant_Item[] = [];

    TrainingSvc: TrainingService;
    ProcessingOverlaySvc: ProcessingOverlayService
    ToastSvc: ToastService;


    constructor(dialogRef: MatDialogRef<ParticipantMatchingComponent>, @Inject(MAT_DIALOG_DATA) dialogData, trainingSvc: TrainingService, processingOverlayService: ProcessingOverlayService,
        toastService: ToastService) {
        Object.assign(this.matchingPersons, dialogData.MatchingPersons);
        this.dialogRef = dialogRef;
        this.showContinueButton = dialogData.showContinueButton;
        this.trainingEventParticipants = dialogData.TrainingEventParticipants;
        this.TrainingSvc = trainingSvc;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.ToastSvc = toastService;
    }

    ngOnInit(): void {
        if (this.showContinueButton) {
            this.warningMessage = 'This participant may already exist in the system.If you recognize a participant below, please select his / her record to continue.If this is a different participant, click "Make Changes" to continue editing data or "Continue" to proceed with existing data.';
        }
        else {
            this.warningMessage = 'A participant with same National ID already exist in the system.If you recognize a participant below, please select his / her record to continue.If this is a different participant, click "Make Changes" to continue editing data.';
        }
        for (let p of this.matchingPersons) {
            p.POB = `${p.POBCityName}, ${p.POBStateName}, ${p.POBCountryName}`;
        }
        this.DataSource = new MatTableDataSource(this.matchingPersons);
        this.DataSource.sort = this.Sort;
        this.LoadMatchingParticipants();
    }

    LoadMatchingParticipants() {

        this.DisplayedColumns = ['FirstMiddleNames', 'LastNames', 'DOB', 'Gender', 'NationalID', 'POB', 'SelectParticipant'];
    }

    SelectMatchingParticipant(selectedMatchingParticipant: MatchingPerson_Item): void {
        this.selectedMatchingPersonID = selectedMatchingParticipant.PersonID;
        this.dialogRef.close(this.selectedMatchingPersonID);
    }

    onCloseClick(): void {
        this.dialogRef.close('Cancel');
    }

    onContinueClick(): void {
        this.dialogRef.close('Continue');
    }

    CanSelect(participant: MatchingPerson_Item): boolean {
        if (this.trainingEventParticipants.filter(p => p.PersonID == participant.PersonID).length > 0)
            return false;
        else
            return true;
    }
}
