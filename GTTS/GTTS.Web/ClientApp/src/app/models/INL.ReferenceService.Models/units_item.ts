


export class Units_Item  {
  
	public UnitID: number = 0;
	public UnitParentID?: number;
	public CountryID: number = 0;
	public UnitLocationID: number = 0;
	public ConsularDistrictID: number = 0;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public IsMainAgency: boolean = false;
	public UnitMainAgencyID: number = 0;
	public UnitAcronym: string = "";
	public UnitGenID: string = "";
	public UnitTypeID: number = 0;
	public GovtLevelID?: number;
	public UnitLevelID?: number;
	public VettingTypeID: number = 0;
	public VettingActivityTypeID: number = 0;
	public ReportingTypeID: number = 0;
	public UnitHeadPersonID: number = 0;
	public UnitHeadJobTitleID?: number;
	public UnitHeadRankID?: number;
	public HQLocationID: number = 0;
	public POCName: string = "";
	public POCEmailAddress: string = "";
	public POCTelephone: string = "";
	public VettingPrefix: string = "";
	public HasDutyToInform: boolean = false;
	public IsLocked: boolean = false;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public Breakdown: string = "";
  
}


