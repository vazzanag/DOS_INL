/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ReportingLayoutComponent } from './reporting-layout.component';

let component: ReportingLayoutComponent;
let fixture: ComponentFixture<ReportingLayoutComponent>;

describe('ReportingLayout Component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ReportingLayoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ReportingLayoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});