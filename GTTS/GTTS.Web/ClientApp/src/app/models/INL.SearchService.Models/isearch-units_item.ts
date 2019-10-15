



export interface ISearchUnits_Item {
  
	UnitID: number;
	UnitAcronym: string;
	UnitName: string;
	UnitNameEnglish: string;
	IsMainAgency: boolean;
	UnitParentID?: number;
	UnitParentName: string;
	UnitParentNameEnglish: string;
	AgencyName: string;
	AgencyNameEnglish: string;
	UnitGenID: string;
	UnitTypeID: number;
	UnitType: string;
	GovtLevelID?: number;
	GovtLevel: string;
	UnitLevelID?: number;
	UnitLevel: string;
	VettingBatchTypeID: number;
	VettingBatchTypeCode: string;
	VettingActivityTypeID: number;
	VettingActivityType: string;
	ReportingTypeID?: number;
	ReportingType: string;
	CommanderFirstName: string;
	CommanderLastName: string;
	CountryID: number;

}

