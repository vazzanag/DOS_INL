import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UnitLibraryLayoutComponent } from './unit-library-layout.component';

describe('UnitLibraryLayoutComponent', () => {
  let component: UnitLibraryLayoutComponent;
  let fixture: ComponentFixture<UnitLibraryLayoutComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UnitLibraryLayoutComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UnitLibraryLayoutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
