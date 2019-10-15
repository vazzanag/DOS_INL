/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PressOverviewComponent } from './press-overview.component';

let component: PressOverviewComponent;
let fixture: ComponentFixture<PressOverviewComponent>;

describe('PressOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PressOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PressOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});