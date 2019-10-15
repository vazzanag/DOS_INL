/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PersonViewComponent } from './person-view.component';

let component: PersonViewComponent;
let fixture: ComponentFixture<PersonViewComponent>;

describe('person-view component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PersonViewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PersonViewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});