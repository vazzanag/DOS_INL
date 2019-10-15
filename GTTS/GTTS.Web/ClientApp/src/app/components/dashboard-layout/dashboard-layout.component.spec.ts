/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { DashboardLayoutComponent } from './dashboard-layout.component';

let component: DashboardLayoutComponent;
let fixture: ComponentFixture<DashboardLayoutComponent>;

describe('DashboardLayout Component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ DashboardLayoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(DashboardLayoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});