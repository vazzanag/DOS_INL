/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { NotificationsBellComponent } from './notifications-bell.component';

let component: NotificationsBellComponent;
let fixture: ComponentFixture<NotificationsBellComponent>;

describe('notifications-bell component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ NotificationsBellComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(NotificationsBellComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});