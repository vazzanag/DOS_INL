/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { NotificationDetailsModalComponent } from './notification-details-modal.component';

let component: NotificationDetailsModalComponent;
let fixture: ComponentFixture<NotificationDetailsModalComponent>;

describe('notification-details-modal component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ NotificationDetailsModalComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(NotificationDetailsModalComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});