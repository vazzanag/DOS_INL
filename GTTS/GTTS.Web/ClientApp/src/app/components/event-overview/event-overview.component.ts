import { Component, OnInit, TemplateRef } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FormGroup, FormControl } from '@angular/forms';
import { trigger, state, style, animate, transition } from '@angular/animations';

import { TrainingEvent } from '@models/training-event';
import { TrainingEventLocation } from '@models/training-event-location';
import { GetTrainingEvent_Result } from "@models/INL.TrainingService.Models/get-training-event_result";
import { GetTrainingEventLocation_Item } from '@models/INL.TrainingService.Models/get-training-event-location_item';

import { TrainingService } from '@services/training.service';
import { BsModalService, BsModalRef } from 'ngx-bootstrap';
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';
import { GetTrainingEventAttachment_Item } from '@models/INL.TrainingService.Models/get-training-event-attachment_item';
import { TrainingEventAttachment } from '@models/training-event-attachment';

@Component({
    selector: 'app-event-overview',
    templateUrl: './event-overview.component.html',
    styleUrls: ['./event-overview.component.scss'],
    animations: [
        trigger('modalFade', [
            state('inactive', style({
                transform: 'rotateY(0)',
                opacity: 0
            })),
            state('active', style({
                transform: 'rotateY(0)',
                opacity: 1
            })),
            transition('inactive => active', [
                animate(500, style({ opacity: 1 }))
            ]),
            transition('active => inactive', [
                animate(500, style({ opacity: 0 }))
            ]),
        ])
    ]
})

export class EventOverviewComponent implements OnInit
{
    Route: ActivatedRoute;
    TrainingService: TrainingService;
    model: TrainingEvent;
    public trainingEventID: number;
    public plannedParticipantCount: number;

    CancelUncancelModalFormGroup = new FormGroup({
        CancelUncancelModalReason: new FormControl()
    });

    constructor(route: ActivatedRoute, trainingService: TrainingService)
    {
        this.Route = route;
        this.TrainingService = trainingService;
        this.plannedParticipantCount = 0;
        this.model = new TrainingEvent();
    }

    /* OnInit implementation */
    public ngOnInit(): void
    {
        this.LoadTrainingEvent();
    }

    // Loads the TrainingEvent model for view
    private LoadTrainingEvent(): void
    {
        // Load training event here
        if (this.Route.snapshot.paramMap.get('trainingEventId') != null)
        {
            // Get ID from URL
            const id = parseInt(this.Route.snapshot.paramMap.get('trainingEventId'));
            if (!isNaN(id))
            {
                this.trainingEventID = id;

                // Get Training Event
                this.TrainingService.GetTrainingEvent(id)
                    .then(result =>
                    {
                        this.model = new TrainingEvent();
                        this.MapModel(result.TrainingEvent);
                    });
            }
            else
            {
                console.error('Training Event ID is not numeric');
            }
        }
        else
        {
            console.error('Training Event ID is not present in route');
        }
    }

    // Maps a GetTrainingEvent_Result object to the TrainingEvent model
    private MapModel(result: GetTrainingEvent_Item): void
    {
        this.model = new TrainingEvent();
        Object.assign(this.model, result);

        this.plannedParticipantCount = this.model.PlannedParticipantCnt + this.model.PlannedMissionDirectHireCnt +
            this.model.PlannedMissionOutsourceCnt + this.model.PlannedNonMissionDirectHireCnt + this.model.PlannedOtherCnt;

        for (let location of this.model.TrainingEventLocations)
        {
            location.EventDateRange = [location.EventStartDate, location.EventEndDate];
            location.TravelDateRange = [location.TravelStartDate, location.TravelEndDate];
        }
        if (result.TrainingEventProjectCodes != null && result.TrainingEventProjectCodes.length > 0) {
            this.model.ProjectCodes = result.TrainingEventProjectCodes.map(p => {
                return p.Code;
            }).join(', ');
        }
    }

    /* EventSummary component "EventClosed" event handler */
    public EventSummary_RefreshTrainingEvent(): void
    {
        this.LoadTrainingEvent();
    }
}
