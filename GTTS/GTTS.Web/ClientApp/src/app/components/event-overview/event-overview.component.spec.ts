/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { EventOverviewComponent } from './event-overview.component';

let component: EventOverviewComponent;
let fixture: ComponentFixture<EventOverviewComponent>;

describe('EventOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ EventOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(EventOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});