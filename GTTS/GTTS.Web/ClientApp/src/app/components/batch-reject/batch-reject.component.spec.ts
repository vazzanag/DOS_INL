import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BatchRejectComponent } from './batch-reject.component';

describe('BatchRejectComponent', () => {
  let component: BatchRejectComponent;
  let fixture: ComponentFixture<BatchRejectComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BatchRejectComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BatchRejectComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
