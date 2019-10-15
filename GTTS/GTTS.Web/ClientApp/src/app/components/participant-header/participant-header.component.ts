import { Component, OnInit, Input } from '@angular/core';
import { TrainingEvent } from '@models/training-event';
import { ActivatedRoute } from '@angular/router';
import { TrainingService } from '@services/training.service';
import { GetTrainingEvent_Result } from '@models/INL.TrainingService.Models/get-training-event_result';
import { TrainingEventProjectCode } from '@models/training-event-project-code';
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';

@Component({
    selector: 'app-participant-header',
    templateUrl: './participant-header.component.html',
    styleUrls: ['./participant-header.component.scss']
})

/** ParticipantHeader component*/
export class ParticipantHeaderComponent implements OnInit {
    TrainingEvent: TrainingEvent;
    Route: ActivatedRoute;
    TrainingSvc: TrainingService;
    TrainingEventID: string;

    @Input('TrainingEvent') InputTrainingEvent: TrainingEvent;

    constructor(route: ActivatedRoute, TrainingService: TrainingService) {
        this.Route = route;
        this.TrainingSvc = TrainingService;
        this.TrainingEvent = new TrainingEvent();
    }

    public FormatProjectCodes(codes: TrainingEventProjectCode[]): string {
        return (codes || []).map(c => c.Code).join(", ");
    }

    public ngOnInit(): void {
        if (null == this.InputTrainingEvent) {
            this.TrainingEventID = this.Route.snapshot.paramMap.get('trainingEventID');

            if (!Number.isNaN(Number(this.TrainingEventID))) {
                this.TrainingSvc.GetTrainingEvent(Number(this.TrainingEventID))
                    .then(event =>
                    {
                        if (event.TrainingEvent)
                            this.MapModel(event.TrainingEvent);
                    })
                    .catch(error => {
                        console.error('Errors in ngOnInit(): ', error);
                    });
            }
            else {
                console.error('Training Event ID is not numeric');
            }
        }
        else {
            this.TrainingEvent = this.InputTrainingEvent;
        }
    }

    private MapModel(result: GetTrainingEvent_Item): void {
        this.TrainingEvent = new TrainingEvent();

        this.TrainingEvent.TrainingEventID = result.TrainingEventID;
        this.TrainingEvent.Name = result.Name;
        this.TrainingEvent.EventStartDate = result.EventStartDate;
        this.TrainingEvent.EventEndDate = result.EventEndDate;
        this.TrainingEvent.TravelStartDate = result.TravelStartDate;
        this.TrainingEvent.TravelEndDate = result.TravelEndDate;
        this.TrainingEvent.NameInLocalLang = result.NameInLocalLang;
        this.TrainingEvent.KeyActivityName = result.KeyActivityName;
        this.TrainingEvent.PlannedParticipantCnt = result.PlannedParticipantCnt;
        this.TrainingEvent.PlannedMissionDirectHireCnt = result.PlannedMissionDirectHireCnt;
        this.TrainingEvent.PlannedNonMissionDirectHireCnt = result.PlannedNonMissionDirectHireCnt;
        this.TrainingEvent.PlannedMissionOutsourceCnt = result.PlannedMissionOutsourceCnt;
        this.TrainingEvent.PlannedOtherCnt = result.PlannedOtherCnt;
        this.TrainingEvent.EstimatedBudget = result.EstimatedBudget;
        this.TrainingEvent.EstimatedStudents = result.EstimatedStudents;
        this.TrainingEvent.TrainingEventProjectCodes = result.TrainingEventProjectCodes;
        this.TrainingEvent.TrainingEventLocations = result.TrainingEventLocations;
        this.TrainingEvent.Organizer = result.Organizer;
        this.TrainingEvent.TravelStartDate = result.TravelStartDate;
        this.TrainingEvent.TravelEndDate = result.TravelEndDate;
        this.TrainingEvent.TrainingEventTypeName = result.TrainingEventTypeName;

        if (result.TrainingEventProjectCodes != null && result.TrainingEventProjectCodes.length > 0) {
            this.TrainingEvent.ProjectCodes = result.TrainingEventProjectCodes.map(p => {
                return p.Code;
            }).join(', ');
        }
        this.TrainingEvent.TrainingEventCourseDefinitionPrograms = result.TrainingEventCourseDefinitionPrograms;
        this.TrainingEvent.TrainingEventLocations = result.TrainingEventLocations;

        if (result.TrainingEventCourseDefinitionPrograms != null && result.TrainingEventCourseDefinitionPrograms.length > 0) {
            this.TrainingEvent.CoursePrograms = result.TrainingEventCourseDefinitionPrograms.map(p => {
                return p.CourseProgram;
            }).join(', ');
        }

        if (result.TrainingEventKeyActivities != null && result.TrainingEventKeyActivities.length > 0) {
            this.TrainingEvent.KeyActivityName = result.TrainingEventKeyActivities.map(p => {
                return p.Code;
            }).join(', ');
        }
        else {
            this.TrainingEvent.KeyActivityName = '';
        }
    }
}
