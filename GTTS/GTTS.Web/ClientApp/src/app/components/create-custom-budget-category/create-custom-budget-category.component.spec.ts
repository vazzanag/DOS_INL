import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateCustomBudgetCategoryComponent } from './create-custom-budget-category.component';

describe('CreateCustomBudgetCategoryComponent', () => {
  let component: CreateCustomBudgetCategoryComponent;
  let fixture: ComponentFixture<CreateCustomBudgetCategoryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CreateCustomBudgetCategoryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CreateCustomBudgetCategoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
