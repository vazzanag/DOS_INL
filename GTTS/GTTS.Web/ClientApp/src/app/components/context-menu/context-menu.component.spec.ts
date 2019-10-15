/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ContextMenuComponent } from './context-menu.component';

let component: ContextMenuComponent;
let fixture: ComponentFixture<ContextMenuComponent>;

describe('context-menu component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ContextMenuComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ContextMenuComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});