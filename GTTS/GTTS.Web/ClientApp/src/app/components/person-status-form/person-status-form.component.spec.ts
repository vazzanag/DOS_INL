/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PersonRemoveFormComponent } from './person-remove-form.component';

let component: PersonRemoveFormComponent;
let fixture: ComponentFixture<PersonRemoveFormComponent>;

describe('person-remove-form component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PersonRemoveFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PersonRemoveFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});