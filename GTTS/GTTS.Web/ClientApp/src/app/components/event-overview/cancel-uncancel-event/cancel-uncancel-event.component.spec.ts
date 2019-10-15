/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { CancelUncancelEventComponent } from './cancel-uncancel-event.component';

let component: CancelUncancelEventComponent;
let fixture: ComponentFixture<CancelUncancelEventComponent>;

describe('CancelUncancelEvent component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ CancelUncancelEventComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(CancelUncancelEventComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});