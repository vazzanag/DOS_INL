/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { TrainingListComponent } from './training-list.component';

let component: TrainingListComponent;
let fixture: ComponentFixture<TrainingListComponent>;

describe('training-list component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ TrainingListComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(TrainingListComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});