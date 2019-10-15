/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { AgenciesListComponent } from './agencies-list.component';

let component: AgenciesListComponent;
let fixture: ComponentFixture<AgenciesListComponent>;

describe('AgenciesList component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ AgenciesListComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(AgenciesListComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});