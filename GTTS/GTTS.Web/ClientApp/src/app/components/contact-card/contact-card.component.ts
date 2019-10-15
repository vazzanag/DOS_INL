import { Component, Input } from '@angular/core';
import { TrainingEventAppUser } from '@models/training-event-appuser';

@Component({
    selector: 'app-contact-card',
    templateUrl: './contact-card.component.html',
    styleUrls: ['./contact-card.component.scss']
})
/** ContactCard component*/
export class ContactCardComponent
{
    @Input() Contact: TrainingEventAppUser;

    /** ContactCard ctor */
    constructor() {

    }
}