/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { VettingHitFormComponent } from './vetting-hit-form.component';

let component: VettingHitFormComponent;
let fixture: ComponentFixture<VettingHitFormComponent>;

describe('vetting-hit component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [VettingHitFormComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(VettingHitFormComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});
