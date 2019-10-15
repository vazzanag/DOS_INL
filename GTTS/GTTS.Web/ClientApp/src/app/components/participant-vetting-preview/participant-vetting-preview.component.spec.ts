/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ParticipantVettingPreviewComponent } from './participant-vetting-preview.component';

let component: ParticipantVettingPreviewComponent;
let fixture: ComponentFixture<ParticipantVettingPreviewComponent>;

describe('ParticipantVettingPreview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ParticipantVettingPreviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ParticipantVettingPreviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});