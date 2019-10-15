import { Component, OnInit, Input, Output, EventEmitter, DoCheck, ViewChild} from '@angular/core';
import { GetTrainingEventBatch_Item } from '@models/INL.TrainingService.Models/get-training-event-batch_item';
import { GetTrainingEventBatchParticipants_Item } from '@models/INL.TrainingService.Models/get-training-event-batch-participants_item';
import { MatTable, MatSort, MatTableDataSource } from '@angular/material';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { IGetTrainingEventBatchParticipants_Item } from '@models/INL.TrainingService.Models/iget-training-event-batch-participants_item';
import { ActivatedRoute } from '@angular/router';

@Component({
    selector: 'app-batch-list',
    templateUrl: './batch-list.component.html',
    styleUrls: ['./batch-list.component.scss']
})

/** BatchList component*/
export class BatchListComponent implements DoCheck, OnInit
{
    private route: ActivatedRoute;

    @ViewChild(MatTable) ParticipantTable: MatTable<any>;
    @ViewChild(MatSort) Sort: MatSort;

    @Input() DisplayFor: string;
    @Input() IsLeahy: boolean;
    @Input() Batch: GetTrainingEventBatch_Item;

    @Output() VettingTypeChangeRequest = new EventEmitter<IGetTrainingEventBatchParticipants_Item>();

    DisplayedColumns: string[];
    TrainingEventID: string;
    DataSource: MatTableDataSource<any>;
    Participants: TrainingEventParticipant[] = [];

    constructor(route: ActivatedRoute)
    {
        this.route = route;
    }

    public ngDoCheck(): void
    {
        if (null != this.ParticipantTable)
        {
            this.ParticipantTable.renderRows();
            this.DataSource = new MatTableDataSource(this.Batch.Participants);
            this.DataSource.sort = this.Sort;
        }

        this.TrainingEventID = this.route.snapshot.paramMap.get('trainingEventID');
    }

    public ngOnInit(): void
    {
        this.Participants = this.Batch.Participants.map(p => 
        {
            return this.MapToTrainingEventParticipant(p);
        });
        this.DataSource = new MatTableDataSource(this.Batch.Participants);
        this.DataSource.sort = this.Sort;

        switch (this.DisplayFor)
        {
            case 'Batch':
                this.DisplayedColumns = ['IsParticipant', 'Ordinal', 'FirstMiddleNames', 'LastNames', 'DOB', 'Gender',
                    'DepartureCity', 'DepartureDate', 'ReturnDate', 'AgencyNameEnglish', 'JobTitle', 'RankName',
                    'ContactEmail', 'EditVetting', 'Visa', 'DocumentsEnd'];
                break;
            case 'Participant':
                this.DisplayedColumns = ['IsParticipant', 'Ordinal', 'FirstMiddleNames', 'LastNames', 'DOB', 'Gender',
                    'DepartureCity', 'DepartureDate', 'ReturnDate', 'AgencyNameEnglish', 'JobTitle', 'RankName',
                    'ContactEmail', 'VettingStatus', 'Visa', 'Documents', 'StatusEnd'];
                break;
            default:
                this.DisplayedColumns = ['IsParticipant', 'Ordinal', 'FirstMiddleNames', 'LastNames', 'DOB', 'Gender',
                    'DepartureCity', 'DepartureDate', 'ReturnDate', 'AgencyNameEnglish', 'JobTitle', 'RankName',
                    'ContactEmail', 'EditVetting', 'Visa', 'DocumentsEnd'];
                break;
        }
    }

    private MapToTrainingEventParticipant(participantInBatch: GetTrainingEventBatchParticipants_Item): TrainingEventParticipant
    {
        let participant = new TrainingEventParticipant();

        participant.PersonID = participantInBatch.PersonID;
        participant.TrainingEventID = participantInBatch.TrainingEventID;
        participant.IsParticipant = participantInBatch.IsParticipant;
        participant.FirstMiddleNames = participantInBatch.FirstMiddleNames;
        participant.LastNames = participantInBatch.LastNames;
        participant.DOB = participantInBatch.DOB;
        participant.Gender = participantInBatch.Gender;
        participant.DepartureCity = participantInBatch.DepartureCity;
        participant.DepartureDate = participantInBatch.DepartureDate;
        participant.ReturnDate = participantInBatch.ReturnDate;
        participant.AgencyName = participantInBatch.AgencyName;
        participant.AgencyNameEnglish = participantInBatch.AgencyNameEnglish;
        participant.UnitID = participantInBatch.UnitID;
        participant.UnitName = participantInBatch.UnitName;
        participant.UnitNameEnglish = participantInBatch.UnitNameEnglish;
        participant.JobTitle = participantInBatch.JobTitle;
        participant.RankName = participantInBatch.RankName;
        participant.ContactEmail = participantInBatch.ContactEmail;
        participant.VisaStatus = participantInBatch.VisaStatus
        participant.IsLeahyVettingReq = participantInBatch.IsLeahyVettingReq;
        participant.IsVettingReq = participantInBatch.IsVettingReq;
        participant.VettingPersonStatus = participantInBatch.VettingPersonStatus;

        return participant;
    }

    public ChangeVettingType(participant: GetTrainingEventBatchParticipants_Item): void
    {
        this.VettingTypeChangeRequest.emit(participant);
    }
}
