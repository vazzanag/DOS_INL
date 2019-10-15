import { Component, Input, OnInit } from '@angular/core';
import { TrainingEvent } from '@models/training-event';

@Component({
    selector: 'app-arrangements-overview',
    templateUrl: './arrangements-overview.component.html',
    styleUrls: ['./arrangements-overview.component.scss']
})
/** ArrangementsOverview component*/
export class ArrangementsOverviewComponent implements OnInit {

    @Input() Training: TrainingEvent = new TrainingEvent();
    StatusPercent: number;
    StatusBarCounter: number;

    /** ArrangementsOverview ctor */
    constructor() {

    }

    public ngOnInit(): void
    {
        this.StatusBarCounter = 0;
        this.StatusPercent = 80;
    }

    public ngAfterViewInit(): void
    {
        setTimeout(() =>
        {
            for (let i = 0; i < this.StatusPercent; i++)
            {
                this.StatusBarCounter++;
            }

        }, 2000);
    }
}