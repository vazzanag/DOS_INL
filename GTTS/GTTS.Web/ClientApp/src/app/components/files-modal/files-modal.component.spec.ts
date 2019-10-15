/// <reference path="../../../../../node_modules/@types/jasmine/index.d.ts" />
import { TestBed, async, ComponentFixture, ComponentFixtureAutoDetect } from '@angular/core/testing';
import { BrowserModule, By } from "@angular/platform-browser";
import { FilesModalComponent } from './files-modal.component';

let component: FilesModalComponent;
let fixture: ComponentFixture<FilesModalComponent>;

describe('FilesModal component', () => {
    beforeEach(async(() => {
        TestBed.configureTestingModule({
            declarations: [ FilesModalComponent ],
            imports: [ BrowserModule ],
            providers: [
                { provide: ComponentFixtureAutoDetect, useValue: true }
            ]
        });
        fixture = TestBed.createComponent(FilesModalComponent);
        component = fixture.componentInstance;
    }));

    it('should do something', async(() => {
        expect(true).toEqual(true);
    }));
});