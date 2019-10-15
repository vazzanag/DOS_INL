


export class BusinessUnits_Item  {
  
	public BusinessUnitID: number = 0;
	public BusinessUnitTypeID: number = 0;
	public BusinessUnit: string = "";
	public Acronym: string = "";
	public BusinessUnitParentID?: number;
	public UnitLibraryUnitID?: number;
	public PostID?: number;
	public Description: string = "";
	public IsActive: boolean = false;
	public IsDeleted: boolean = false;
	public HasPrograms: boolean = false;
	public LogoFileName: string = "";
	public VettingPrefix: string = "";
	public hasDutyToInform: boolean = false;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}


