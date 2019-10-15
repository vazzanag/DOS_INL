/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { GttsLayoutComponent } from './gttsmain.component';

let component: GttsLayoutComponent;
let fixture: ComponentFixture<GttsLayoutComponent>;

describe('GTTSLayout Component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ GttsLayoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(GttsLayoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});