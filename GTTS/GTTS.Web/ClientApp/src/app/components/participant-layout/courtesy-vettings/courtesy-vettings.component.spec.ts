/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { CourtesyVettingsComponent } from './courtesy-vettings.component';

let component: CourtesyVettingsComponent;
let fixture: ComponentFixture<CourtesyVettingsComponent>;

describe('CourtesyVettings component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ CourtesyVettingsComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(CourtesyVettingsComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});