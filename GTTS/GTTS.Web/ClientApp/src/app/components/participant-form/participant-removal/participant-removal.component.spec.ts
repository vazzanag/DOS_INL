/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ParticipantRemovalComponent } from './participant-removal.component';

let component: ParticipantRemovalComponent;
let fixture: ComponentFixture<ParticipantRemovalComponent>;

describe('ParticipantRemoval component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ParticipantRemovalComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ParticipantRemovalComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});