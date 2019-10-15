/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { MessagingLayoutComponent } from './messaging-layout.component';

let component: MessagingLayoutComponent;
let fixture: ComponentFixture<MessagingLayoutComponent>;

describe('MessagingLayout Component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ MessagingLayoutComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(MessagingLayoutComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});