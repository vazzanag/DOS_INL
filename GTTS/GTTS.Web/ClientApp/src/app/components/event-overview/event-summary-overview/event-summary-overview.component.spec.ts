/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { EventSummaryComponent } from './event-summary.component';

let component: EventSummaryComponent;
let fixture: ComponentFixture<EventSummaryComponent>;

describe('EventSummary component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ EventSummaryComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(EventSummaryComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});