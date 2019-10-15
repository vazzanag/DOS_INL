/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PersonVettingHistoryComponent } from './person-vetting-history.component';

let component: PersonVettingHistoryComponent;
let fixture: ComponentFixture<PersonVettingHistoryComponent>;

describe('person-vetting-history component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PersonVettingHistoryComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PersonVettingHistoryComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});