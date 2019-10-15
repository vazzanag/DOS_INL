/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ParticipantEditVetterComponent } from './participant-edit-vetter.component';

let component: ParticipantEditVetterComponent;
let fixture: ComponentFixture<ParticipantEditVetterComponent>;

describe('participant-edit-vetter component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ParticipantEditVetterComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ParticipantEditVetterComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});