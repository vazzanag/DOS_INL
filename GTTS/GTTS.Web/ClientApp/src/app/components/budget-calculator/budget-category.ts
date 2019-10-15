import { CalculatorLocation } from './calculator-location';

export class BudgetCategory {
    public categoryID?: number;
    public customCategoryID?: number;
    public name: string;
    public locations: CalculatorLocation[];
    public focusedLocations: CalculatorLocation[];
    public get isSingleLocationFocused(): boolean {
        return this.focusedLocations.filter(l => l.locationID == null).length != 0;
    }
    public get isIncluded(): boolean {
        let numLocations = this.locations.length;
        for (let i = 0; i < numLocations; i++) {
            let location = this.locations[i];
            if (location.isIncluded)
                return true;
        }
        return false;
    }
    public get total(): number {
        let total = 0;
        let numLocations = this.locations.length;
        for (let i = 0; i < numLocations; i++) {
            let location = this.locations[i];
            let numItems = location.budgetItems.length;
            for (let j = 0; j < numItems; j++) {
                let item = location.budgetItems[j];
                if (item.isIncluded) {
                    total += item.total;
                }
            }
        }
        return total;
    }

    public get flatLocationsBudgetItems(): any[] {
        let result: any[] = [];
        let locations = this.locations.sort((a, b) => a.locationID == null ? -1 : 1);
        locations.forEach(l => {
            let locationWrapper: any;
            locationWrapper = { isLocation: true, item: l }
            result.push(locationWrapper);
            l.budgetItems.forEach(i => {
                let budgetItemWrapper: any;
                budgetItemWrapper = { isLocation: false, item: i }
                result.push(budgetItemWrapper);
            })
        });
        return result;
    }
}
