/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { NotificationRedirectComponent } from './notification-redirect.component';

let component: NotificationRedirectComponent;
let fixture: ComponentFixture<NotificationRedirectComponent>;

describe('NotificationRedirect component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ NotificationRedirectComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(NotificationRedirectComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});