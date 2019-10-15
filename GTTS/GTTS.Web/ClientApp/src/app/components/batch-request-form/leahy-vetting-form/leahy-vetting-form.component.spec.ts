/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { LeahyVettingFormComponent } from './leahy-vetting-form.component';

let component: LeahyVettingFormComponent;
let fixture: ComponentFixture<LeahyVettingFormComponent>;

describe('leahy-vetting-form component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ LeahyVettingFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(LeahyVettingFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});