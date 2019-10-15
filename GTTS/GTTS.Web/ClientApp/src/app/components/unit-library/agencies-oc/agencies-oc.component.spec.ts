import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AgenciesOcComponent } from './agencies-oc.component';

describe('AgenciesOcComponent', () => {
  let component: AgenciesOcComponent;
  let fixture: ComponentFixture<AgenciesOcComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AgenciesOcComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AgenciesOcComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
