import { Component, Input, OnInit } from '@angular/core';
import { trigger, state, style, animate, transition } from '@angular/animations';

@Component({
    selector: 'app-status-block',
    templateUrl: './status-block.component.html',
    styleUrls: ['./status-block.component.scss'],
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
/** StatusBlock component*/
export class StatusBlockComponent implements OnInit
{
    @Input() HeaderText: string;
    @Input() Person: string;
    @Input() Status: string;

    ImageName: string;
    ImageAlt: string;
    Color: string;
    flip: string = 'inactive';

    constructor()  {  }

    public ngOnInit(): void
    {
        switch (this.Status)
        {
            case 'Submitted For Approval':
                this.ImageName = 'paper-plane.svg';
                this.ImageAlt = 'paper plane';
                this.Color = '#B5D641';
                break;
            case 'Pending Approval':
                this.ImageName = 'clock.svg';
                this.ImageAlt = 'clock';
                this.Color = '#DAA302';
                break;
            case 'Approved':
                this.ImageName = 'check.svg';
                this.ImageAlt = 'checkmark';
                this.Color = '#B5D641';
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

    public 
}