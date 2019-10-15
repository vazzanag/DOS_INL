/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { UnitFormComponent } from './unit-form.component';

let component: UnitFormComponent;
let fixture: ComponentFixture<UnitFormComponent>;

describe('UnitForm component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ UnitFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(UnitFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});