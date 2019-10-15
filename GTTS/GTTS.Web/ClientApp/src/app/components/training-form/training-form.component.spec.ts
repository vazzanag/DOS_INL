/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { TrainingFormComponent } from './training-form.component';

let component: TrainingFormComponent;
let fixture: ComponentFixture<TrainingFormComponent>;

describe('training-form component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ TrainingFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(TrainingFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});