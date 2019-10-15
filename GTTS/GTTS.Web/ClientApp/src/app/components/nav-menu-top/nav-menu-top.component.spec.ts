import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NavMenuTopComponent } from './nav-menu-top.component';

describe('NavMenuTopComponent', () => {
  let component: NavMenuTopComponent;
  let fixture: ComponentFixture<NavMenuTopComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NavMenuTopComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NavMenuTopComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
