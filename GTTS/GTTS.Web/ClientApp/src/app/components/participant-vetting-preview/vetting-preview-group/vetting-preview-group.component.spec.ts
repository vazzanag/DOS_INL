/// <reference path="../../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { VettingPreviewGroupComponent } from './vetting-preview-group.component';

let component: VettingPreviewGroupComponent;
let fixture: ComponentFixture<VettingPreviewGroupComponent>;

describe('vetting-preview-group component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ VettingPreviewGroupComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(VettingPreviewGroupComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});