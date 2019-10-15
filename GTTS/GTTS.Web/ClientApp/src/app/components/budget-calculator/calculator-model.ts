import { BudgetCategory } from './budget-category';

export class CalculatorModel {
    public get total(): number {
        let total = 0;
        let numCategories = this.categories.length;
        for (let i = 0; i < numCategories; i++) {
            let category = this.categories[i];
            if (category.isIncluded)
                total += category.total;
        }
        return total;
    }
    public categories: BudgetCategory[];
    public defaultNumPersons: number;
    public trainingEventName: string;
    public trainingEventStart: Date;
    public trainingEventEnd: Date;
}
