/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { StatusOverviewComponent } from './status-overview.component';

let component: StatusOverviewComponent;
let fixture: ComponentFixture<StatusOverviewComponent>;

describe('StatusOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ StatusOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(StatusOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});