/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { BatchRequestFormComponent } from './batch-request-form.component';

let component: BatchRequestFormComponent;
let fixture: ComponentFixture<BatchRequestFormComponent>;

describe('batch-request-form component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ BatchRequestFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(BatchRequestFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});