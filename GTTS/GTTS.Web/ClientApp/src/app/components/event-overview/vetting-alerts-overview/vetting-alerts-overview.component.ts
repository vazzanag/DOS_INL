import { Component, Input, OnInit } from '@angular/core';
import { TrainingEvent } from '@models/training-event';
import { MatProgressBar } from '@angular/material'
import { AuthService } from '@services/auth.service';

@Component({
    selector: 'app-vetting-alerts-overview',
    templateUrl: './vetting-alerts-overview.component.html',
    styleUrls: ['./vetting-alerts-overview.component.scss']
})
/** VettingAlertsOverview component*/
export class VettingAlertsOverviewComponent implements OnInit
{
    @Input() Training: TrainingEvent = new TrainingEvent();
    StatusPercent: number;
    StatusBarCounter: number;
    ProgressBarColor: string;
    public AuthSrvc: AuthService;

    /** VettingAlertsOverview ctor */
    constructor(
        AuthSrvc: AuthService)
    {
        this.StatusPercent = 80;
        this.StatusBarCounter = 0;
        this.ProgressBarColor = 'yellow';
        this.AuthSrvc = AuthSrvc;
    }

    public ngOnInit(): void
    {
        
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
