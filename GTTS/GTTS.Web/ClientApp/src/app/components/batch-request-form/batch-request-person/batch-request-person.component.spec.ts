/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { BatchRequestPersonComponent } from './batch-request-person.component';

let component: BatchRequestPersonComponent;
let fixture: ComponentFixture<BatchRequestPersonComponent>;

describe('batch-request-person component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ BatchRequestPersonComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(BatchRequestPersonComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});