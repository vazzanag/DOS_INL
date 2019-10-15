


export class CustomBudgetItem_Item {
  
	public CustomBudgetItemID?: number;
	public TrainingEventID?: number;
	public IsIncluded: boolean = false;
	public LocationID?: number;
	public BudgetCategoryID?: number;
	public CustomBudgetCategoryID?: number;
	public SupportsQuantity: boolean = false;
	public SupportsPeopleCount: boolean = false;
	public SupportsTimePeriodsCount: boolean = false;
	public Name: string = "";
	public Cost: number = 0;
	public Quantity?: number;
	public PeopleCount?: number;
	public TimePeriodsCount?: number;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}


