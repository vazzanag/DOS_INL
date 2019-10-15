/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { PersonViewLayoutComponent } from './person-view-layout.component';

let component: PersonViewLayoutComponent;
let fixture: ComponentFixture<PersonViewLayoutComponent>;

describe('person-view-layout component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ PersonViewLayoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(PersonViewLayoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});