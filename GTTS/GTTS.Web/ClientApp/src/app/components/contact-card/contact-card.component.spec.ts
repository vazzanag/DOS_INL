/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { ContactCardComponent } from './contact-card.component';

let component: ContactCardComponent;
let fixture: ComponentFixture<ContactCardComponent>;

describe('ContactCard component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ ContactCardComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(ContactCardComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});