/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { FeedbackOverviewComponent } from './feedback-overview.component';

let component: FeedbackOverviewComponent;
let fixture: ComponentFixture<FeedbackOverviewComponent>;

describe('FeedbackOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ FeedbackOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(FeedbackOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});