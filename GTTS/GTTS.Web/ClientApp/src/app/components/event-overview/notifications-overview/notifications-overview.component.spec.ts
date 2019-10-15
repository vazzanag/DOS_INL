/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { NotificationsOverviewComponent } from './notifications-overview.component';

let component: NotificationsOverviewComponent;
let fixture: ComponentFixture<NotificationsOverviewComponent>;

describe('NotificationsOverview component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ NotificationsOverviewComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(NotificationsOverviewComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});