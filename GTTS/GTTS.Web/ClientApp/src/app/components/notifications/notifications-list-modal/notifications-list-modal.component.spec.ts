/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { NotificationsListModalComponent } from './notifications-list-modal.component';

let component: NotificationsListModalComponent;
let fixture: ComponentFixture<NotificationsListModalComponent>;

describe('notifications-list-modal component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ NotificationsListModalComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(NotificationsListModalComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});