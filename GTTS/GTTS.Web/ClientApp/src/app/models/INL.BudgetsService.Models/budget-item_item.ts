


export class BudgetItem_Item {
  
	public BudgetItemID?: number;
	public TrainingEventID: number = 0;
	public IsIncluded: boolean = false;
	public LocationID?: number;
	public BudgetItemTypeID: number = 0;
	public BudgetItemType: string = "";
	public BudgetCategoryID: number = 0;
	public BudgetCategory: string = "";
	public Cost: number = 0;
	public Quantity?: number;
	public PeopleCount?: number;
	public TimePeriodsCount?: number;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}


