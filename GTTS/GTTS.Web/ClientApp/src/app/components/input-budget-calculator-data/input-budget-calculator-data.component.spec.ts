import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InputBudgetCalculatorDataComponent } from './input-budget-calculator-data.component';

describe('InputBudgetCalculatorDataComponent', () => {
  let component: InputBudgetCalculatorDataComponent;
  let fixture: ComponentFixture<InputBudgetCalculatorDataComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InputBudgetCalculatorDataComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InputBudgetCalculatorDataComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
