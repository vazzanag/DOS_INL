/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { AgencyUnitsListComponent } from './agency-units-list.component';

let component: AgencyUnitsListComponent;
let fixture: ComponentFixture<AgencyUnitsListComponent>;

describe('AgencyUnitsList component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ AgencyUnitsListComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(AgencyUnitsListComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});