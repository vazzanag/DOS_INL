import { Component, Input, OnInit } from '@angular/core';
import { trigger, state, style, animate, transition } from '@angular/animations';

@Component({
    selector: 'app-arrangements-block',
    templateUrl: './arrangements-block.component.html',
    styleUrls: ['./arrangements-block.component.scss'],
    animations: [
        trigger('flipLoad', [
            state('inactive', style({
                transform: 'rotateY(0)',
                opacity: 0
            })),
            state('loading', style({
                transform: 'rotateY(0)',
                opacity: 1
            })),
            state('active', style({
                transform: 'rotateY(179.9deg)',
                opacity: 1
            })),
            transition('inactive => loading', [
                animate(500, style({ opacity: 1 }))
            ]),
            transition('inactive => active', [
                animate('500ms ease-in')
            ])
        ])
    ]
})
/** ArrangementsBlock component*/
export class ArrangementsBlockComponent implements OnInit {

    @Input() Value: string;
    @Input() Status: string;

    Color: string;
    CssClass: string;
    flip: string = 'inactive';

    /** ArrangementsBlock ctor */
    constructor() {

    }

    public ngOnInit(): void
    {
        switch (this.Status)
        {
            case 'Complete':
                this.Color = '#0872A7';
                this.CssClass = 'overviewArrangementsComplete';
                break;
            case 'In Progress':
                this.Color = '#DAA302';
                this.CssClass = 'overviewArrangementsInProgress';
                break;
            case 'N/A':
                this.Color = '#707070';
                this.CssClass = 'overviewArrangementsNa';
                break;
        }

        setTimeout(() =>
        {
            this.flip = 'loading';
            setTimeout(() =>
            {
                this.flip = 'active';
            }, 2000);
        }, 100);
    }
}