/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ProcurementOverviewComponent } from './procurement-overview.component';

let component: ProcurementOverviewComponent;
let fixture: ComponentFixture<ProcurementOverviewComponent>;

describe('ProcurementOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ProcurementOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ProcurementOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});