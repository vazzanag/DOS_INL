/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { StatusBlockComponent } from './status-block.component';

let component: StatusBlockComponent;
let fixture: ComponentFixture<StatusBlockComponent>;

describe('StatusBlock component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ StatusBlockComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(StatusBlockComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});