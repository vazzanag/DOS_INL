/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { NavMenuComponent } from './nav-menu.component';

let component: NavMenuComponent;
let fixture: ComponentFixture<NavMenuComponent>;

describe('navMenu component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ NavMenuComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(NavMenuComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});