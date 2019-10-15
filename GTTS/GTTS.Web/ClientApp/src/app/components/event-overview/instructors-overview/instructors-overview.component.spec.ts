/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { InstructorsComponent } from './instructors.component';

let component: InstructorsComponent;
let fixture: ComponentFixture<InstructorsComponent>;

describe('Instructors component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ InstructorsComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(InstructorsComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});