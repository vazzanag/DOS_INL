/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { InstructorAddBySearchComponent } from './instructor-add-by-search.component';

let component: InstructorAddBySearchComponent;
let fixture: ComponentFixture<InstructorAddBySearchComponent>;

describe('instructor-add-by-search component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ InstructorAddBySearchComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(InstructorAddBySearchComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});