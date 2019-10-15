/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { LandingLayoutComponent } from './landing-layout.component';

let component: LandingLayoutComponent;
let fixture: ComponentFixture<LandingLayoutComponent>;

describe('landingPage component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ LandingLayoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(LandingLayoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});
