import { Component, Input, OnInit } from '@angular/core';
import { TrainingEvent } from '@models/training-event';

@Component({
    selector: 'app-status-overview',
    templateUrl: './status-overview.component.html',
    styleUrls: ['./status-overview.component.scss']
})
/** StatusOverview component*/
export class StatusOverviewComponent implements OnInit
{
    @Input() Training: TrainingEvent = new TrainingEvent();

    /** StatusOverview ctor */
    constructor() {

    }
    public ngOnInit(): void
    {
    }
}