

import { ISearchUnits_Item } from './isearch-units_item';

export class SearchUnits_Item implements ISearchUnits_Item {
  
	public UnitID: number = 0;
	public UnitAcronym: string = "";
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public IsMainAgency: boolean = false;
	public UnitParentID?: number;
	public UnitParentName: string = "";
	public UnitParentNameEnglish: string = "";
	public AgencyName: string = "";
	public AgencyNameEnglish: string = "";
	public UnitGenID: string = "";
	public UnitTypeID: number = 0;
	public UnitType: string = "";
	public GovtLevelID?: number;
	public GovtLevel: string = "";
	public UnitLevelID?: number;
	public UnitLevel: string = "";
	public VettingBatchTypeID: number = 0;
	public VettingBatchTypeCode: string = "";
	public VettingActivityTypeID: number = 0;
	public VettingActivityType: string = "";
	public ReportingTypeID?: number;
	public ReportingType: string = "";
	public CommanderFirstName: string = "";
	public CommanderLastName: string = "";
	public CountryID: number = 0;
  
}


