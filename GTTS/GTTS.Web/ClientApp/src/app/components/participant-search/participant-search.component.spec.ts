/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ParticipantSearchComponent } from './participant-search.component';

let component: ParticipantSearchComponent;
let fixture: ComponentFixture<ParticipantSearchComponent>;

describe('ParticipantSearch component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ParticipantSearchComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ParticipantSearchComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});