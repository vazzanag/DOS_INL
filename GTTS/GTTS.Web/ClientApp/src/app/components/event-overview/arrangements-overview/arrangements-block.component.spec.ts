/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ArrangementsBlockComponent } from './arrangements-block.component';

let component: ArrangementsBlockComponent;
let fixture: ComponentFixture<ArrangementsBlockComponent>;

describe('ArrangementsBlock component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ArrangementsBlockComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ArrangementsBlockComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});