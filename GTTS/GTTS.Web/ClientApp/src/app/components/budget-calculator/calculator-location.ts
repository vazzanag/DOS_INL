import { BudgetItem } from './budget-item';

export class CalculatorLocation {
    public locationID?: number;
    public cityID: number;
    public name: string;
    public budgetItems: BudgetItem[];

    public get isIncluded(): boolean {
        let numItems = this.budgetItems.length;
        for (let j = 0; j < numItems; j++) {
            let item = this.budgetItems[j];
            if (item.isIncluded)
                return true;
        }
        return false;
    }

    public get supportsQuantity(): boolean {
        return this.budgetItems.filter(i => i.supportsQuantity).length != 0;
    }
    public get supportsPeopleCount(): boolean {
        return this.budgetItems.filter(i => i.supportsNumPersons).length != 0;
    }
    public get supportsTimePeriodsCount(): boolean {
        return this.budgetItems.filter(i => i.supportsNumTimePeriods).length != 0;
    }
    public get hotelBudgetItem(): BudgetItem {
        let hotelItem = this.budgetItems.filter(i => i.itemTypeID == 24)[0];
        return hotelItem;
    }
    public get isUsingHotelGsaRates(): boolean {
        return this.hotelBudgetItem.defaultCost == this.hotelBudgetItem.cost; 
    }
    public defaultNumEventDays: number;
    public defaultNumTravelDays: number;
}
