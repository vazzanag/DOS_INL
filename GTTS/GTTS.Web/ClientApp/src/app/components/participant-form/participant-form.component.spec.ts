/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ParticipantFormComponent } from './participant-form.component';

let component: ParticipantFormComponent;
let fixture: ComponentFixture<ParticipantFormComponent>;

describe('ParticipantForm component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ParticipantFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ParticipantFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});