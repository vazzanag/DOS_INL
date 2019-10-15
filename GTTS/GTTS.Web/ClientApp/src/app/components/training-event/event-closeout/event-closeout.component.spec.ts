/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { EventCloseoutComponent } from './event-closeout.component';

let component: EventCloseoutComponent;
let fixture: ComponentFixture<EventCloseoutComponent>;

describe('EventCloseout component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ EventCloseoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(EventCloseoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});