﻿/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ProcessingOverlayComponent } from './processing-overlay.component';

let component: ProcessingOverlayComponent;
let fixture: ComponentFixture<ProcessingOverlayComponent>;

describe('ProcessingOverlay component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ProcessingOverlayComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ProcessingOverlayComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});