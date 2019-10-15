/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PerformanceRosterDetailsComponent } from './performance-roster-details.component';

let component: PerformanceRosterDetailsComponent;
let fixture: ComponentFixture<PerformanceRosterDetailsComponent>;

describe('PerformanceRosterDetails component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PerformanceRosterDetailsComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PerformanceRosterDetailsComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});