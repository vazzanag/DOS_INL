/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { VettingFundingFormComponent } from './vetting-funding-form.component';

let component: VettingFundingFormComponent;
let fixture: ComponentFixture<VettingFundingFormComponent>;

describe('vetting-funding-form component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ VettingFundingFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(VettingFundingFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});