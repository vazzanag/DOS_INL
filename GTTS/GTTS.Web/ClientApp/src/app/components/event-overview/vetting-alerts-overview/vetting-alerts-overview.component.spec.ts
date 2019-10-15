/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { VettingAlertsOverviewComponent } from './vetting-alerts-overview.component';

let component: VettingAlertsOverviewComponent;
let fixture: ComponentFixture<VettingAlertsOverviewComponent>;

describe('VettingAlertsOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ VettingAlertsOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(VettingAlertsOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});