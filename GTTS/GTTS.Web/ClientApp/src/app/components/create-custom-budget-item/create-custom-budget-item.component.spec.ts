import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateCustomBudgetItemComponent } from './create-custom-budget-item.component';

describe('CreateCustomBudgetItemComponent', () => {
  let component: CreateCustomBudgetItemComponent;
  let fixture: ComponentFixture<CreateCustomBudgetItemComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CreateCustomBudgetItemComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CreateCustomBudgetItemComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
