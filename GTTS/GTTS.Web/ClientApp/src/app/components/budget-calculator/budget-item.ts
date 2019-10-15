export class BudgetItem {
    public budgetItemID?: number;
    public itemTypeID?: number;
    public customItemID: number;
    public description: string;
    public isIncluded: boolean;
    public cost: number;
    public defaultCost: number;
    public isCostConfigurable: boolean = true;
    public quantity?: number;
    public numPersons?: number;
    public numTimePeriods?: number;
    public supportsQuantity: boolean;
    public supportsNumPersons: boolean;
    public supportsNumTimePeriods: boolean;
    public get total(): number {
        let total = this.cost;
        if (this.supportsQuantity)
            total *= this.quantity;
        if (this.supportsNumPersons)
            total *= this.numPersons;
        if (this.supportsNumTimePeriods)
            total *= this.numTimePeriods;
        return total;
    }
}
