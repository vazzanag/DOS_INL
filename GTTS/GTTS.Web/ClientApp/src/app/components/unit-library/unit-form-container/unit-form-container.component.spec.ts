/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { UnitFormContainerComponent } from './unit-form-container.component';

let component: UnitFormContainerComponent;
let fixture: ComponentFixture<UnitFormContainerComponent>;

describe('UnitFormContainer component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ UnitFormContainerComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(UnitFormContainerComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});