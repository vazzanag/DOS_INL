/// <reference path="../../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PersonUnitViewComponent } from './person-unit-view.component';

let component: PersonUnitViewComponent;
let fixture: ComponentFixture<PersonUnitViewComponent>;

describe('person-unit-view component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PersonUnitViewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PersonUnitViewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});