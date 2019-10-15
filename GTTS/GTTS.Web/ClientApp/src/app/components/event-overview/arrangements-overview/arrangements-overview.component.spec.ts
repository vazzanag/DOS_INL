/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ArrangementsOverviewComponent } from './arrangements-overview.component';

let component: ArrangementsOverviewComponent;
let fixture: ComponentFixture<ArrangementsOverviewComponent>;

describe('ArrangementsOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ArrangementsOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ArrangementsOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});