/// <reference path="../../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PersonTrainingHistoryComponent } from './person-training-history.component';

let component: PersonTrainingHistoryComponent;
let fixture: ComponentFixture<PersonTrainingHistoryComponent>;

describe('person-training-history component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PersonTrainingHistoryComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PersonTrainingHistoryComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});