/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { TrainingBatchesComponent } from './training-batches.component';

let component: TrainingBatchesComponent;
let fixture: ComponentFixture<TrainingBatchesComponent>;

describe('TrainingBatches component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ TrainingBatchesComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(TrainingBatchesComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});