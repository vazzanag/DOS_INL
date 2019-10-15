import { Component, Input } from '@angular/core';

import { TrainingEvent } from '@models/training-event';

@Component({
    selector: 'app-feedback-overview',
    templateUrl: './feedback-overview.component.html',
    styleUrls: ['./feedback-overview.component.scss']
})
/** FeedbackOverview component*/
export class FeedbackOverviewComponent
{
    @Input() Training: TrainingEvent;

    constructor()
    {

    }
}