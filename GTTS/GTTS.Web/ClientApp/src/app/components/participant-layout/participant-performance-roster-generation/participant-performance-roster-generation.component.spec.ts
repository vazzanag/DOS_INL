/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ParticipantPerformanceRosterGenerationComponent } from './participant-performance-roster-generation.component';

let component: ParticipantPerformanceRosterGenerationComponent;
let fixture: ComponentFixture<ParticipantPerformanceRosterGenerationComponent>;

describe('ParticipantPerformanceRosterGeneration component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ParticipantPerformanceRosterGenerationComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ParticipantPerformanceRosterGenerationComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});
