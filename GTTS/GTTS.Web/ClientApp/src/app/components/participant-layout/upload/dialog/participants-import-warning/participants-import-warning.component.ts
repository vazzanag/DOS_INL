import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';
import { TrainingEventParticipantXLSX_Item } from '@models/INL.TrainingService.Models/training-event-participant-xlsx_item';

@Component({
    selector: 'app-participants-import-warning',
    templateUrl: './participants-import-warning.component.html',
    styleUrls: ['./participants-import-warning.component.scss']
})

export class ParticipantsImportWarningComponent {
    dialogRef: MatDialogRef<ParticipantsImportWarningComponent>;
    InvalidParticipants: TrainingEventParticipantXLSX_Item[] = [];
    RejectedLeahyParticipants: TrainingEventParticipantXLSX_Item[] = [];
    SuspendedLeahyParticipants: TrainingEventParticipantXLSX_Item[] = [];
    RejectedCourtesyParticipants: TrainingEventParticipantXLSX_Item[] = [];

    constructor(dialogRef: MatDialogRef<ParticipantsImportWarningComponent>, @Inject(MAT_DIALOG_DATA) dialogData) {
        this.dialogRef = dialogRef;;
        this.InvalidParticipants = dialogData.InvalidParticipants;
        this.RejectedLeahyParticipants = dialogData.RejectedLeahyParticipants;
        this.SuspendedLeahyParticipants = dialogData.SuspendedLeahyParticipants;
        this.RejectedCourtesyParticipants = dialogData.RejectedCourtesyParticipants;
    }

    OnCancelClick(): void {
        this.dialogRef.close('Cancel');
    }

    public OnOkClick() {
        this.dialogRef.close('Ok');
    }


    public GetInvalidProperties(participant: TrainingEventParticipantXLSX_Item): string[]
    {
        let errors: string[] = [];

        if (!participant.IsNationalIDValid)
            errors.push(participant.NationalIDValidationMessage);
        if (!participant.IsNameValid)
            errors.push(participant.NameValidationMessage);
        if (!participant.IsGenderValid)
            errors.push(participant.GenderValidationMessage);
        if (!participant.IsDOBValid)
            errors.push(participant.DOBValidationMessage);
        if (!participant.IsPOBValid)
            errors.push(participant.POBValidationMessage);
        if (!participant.IsResidenceCountryValid)
            errors.push(participant.ResidenceCountryValidationMessage);
        if (!participant.IsResidenceStateValid)
            errors.push(participant.ResidenceStateValidationMessage);
        if (!participant.IsEducationLevelValid)
            errors.push(participant.EducationLevelValidationMessage);
        if (!participant.IsEnglishLanguageProficiencyValid)
            errors.push(participant.EnglishLanguageProficiencyValidationMessage);
        if (!participant.IsUnitGenIDValid)
            errors.push(participant.UnitGenIDValidationMessage);
        if (!participant.IsUnitValid)
            errors.push(participant.UnitValidationMessage);
        if (!participant.IsRankValid)
            errors.push(participant.RankValidationMessage);

        return errors;
    }
}
