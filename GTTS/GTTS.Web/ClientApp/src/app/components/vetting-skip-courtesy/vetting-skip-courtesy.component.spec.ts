/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { VettingSkipCourtesyComponent } from './vetting-skip-courtesy.component';

let component: VettingSkipCourtesyComponent;
let fixture: ComponentFixture<VettingSkipCourtesyComponent>;

describe('vetting-skip-courtesy component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ VettingSkipCourtesyComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(VettingSkipCourtesyComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});