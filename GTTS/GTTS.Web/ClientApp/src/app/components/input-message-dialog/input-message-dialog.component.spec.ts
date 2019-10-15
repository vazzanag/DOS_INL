import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InputMessageDialogComponent } from './input-message-dialog.component';

describe('InputMessageDialogComponent', () => {
  let component: InputMessageDialogComponent;
  let fixture: ComponentFixture<InputMessageDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InputMessageDialogComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InputMessageDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
