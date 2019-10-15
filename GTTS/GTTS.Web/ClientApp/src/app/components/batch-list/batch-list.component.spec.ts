/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { BatchListComponent } from './batch-list.component';

let component: BatchListComponent;
let fixture: ComponentFixture<BatchListComponent>;

describe('BatchList component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ BatchListComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(BatchListComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});