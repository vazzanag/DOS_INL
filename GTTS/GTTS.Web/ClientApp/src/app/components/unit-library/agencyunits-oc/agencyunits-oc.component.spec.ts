import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AgencyunitsOcComponent } from './agencyunits-oc.component';

describe('AgencyunitsOcComponent', () => {
  let component: AgencyunitsOcComponent;
  let fixture: ComponentFixture<AgencyunitsOcComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AgencyunitsOcComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AgencyunitsOcComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
