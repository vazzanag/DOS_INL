import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MessagesBellComponent } from './messages-bell.component';

describe('MessagesBellComponent', () => {
  let component: MessagesBellComponent;
  let fixture: ComponentFixture<MessagesBellComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MessagesBellComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MessagesBellComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
