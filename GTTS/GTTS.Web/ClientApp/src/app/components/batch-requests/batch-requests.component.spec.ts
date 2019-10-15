import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BatchRequestsComponent } from './batch-requests.component';

describe('BatchRequestsComponent', () => {
  let component: BatchRequestsComponent;
  let fixture: ComponentFixture<BatchRequestsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BatchRequestsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BatchRequestsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
