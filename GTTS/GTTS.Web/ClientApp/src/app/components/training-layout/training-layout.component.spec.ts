/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { TrainingLayoutComponent } from './training-layout.component';

let component: TrainingLayoutComponent;
let fixture: ComponentFixture<TrainingLayoutComponent>;

describe('TrainingLayout Component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ TrainingLayoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(TrainingLayoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});