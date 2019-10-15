import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { StartThreadComponent } from './start-thread.component';

describe('StartThreadComponent', () => {
  let component: StartThreadComponent;
  let fixture: ComponentFixture<StartThreadComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ StartThreadComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(StartThreadComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
