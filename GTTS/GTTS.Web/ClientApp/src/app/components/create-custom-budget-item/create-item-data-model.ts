import { BudgetCategory } from '@components/budget-calculator/budget-category';
import { CalculatorLocation } from '@components/budget-calculator/calculator-location';
import { CustomBudgetItem } from './custom-budget-item';

export class CreateItemDataModel {
    public category: BudgetCategory;
    public location: CalculatorLocation;
    public item: CustomBudgetItem;
}
