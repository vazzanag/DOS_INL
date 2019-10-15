

import { GetUnitAlias_Item } from './get-unit-alias_item';
import { GetUnitLocation_Item } from './get-unit-location_item';
import { GetUnitCommander_Item } from './get-unit-commander_item';
import { IUnit_Item } from './iunit_item';

export class Unit_Item implements IUnit_Item {
  
	public UnitID: number = 0;
	public UnitParentID?: number;
	public UnitParentName: string = "";
	public UnitParentNameEnglish: string = "";
	public AgencyName: string = "";
	public AgencyNameEnglish: string = "";
	public UnitAgencyName: string = "";
	public UnitParents: string = "";
	public UnitBreakdown: string = "";
	public UnitBreakdownLocalLang: string = "";
	public CountryID: number = 0;
	public CountryName: string = "";
	public UnitLocationID?: number;
	public ConsularDistrictID?: number;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public IsMainAgency: boolean = false;
	public UnitMainAgencyID?: number;
	public UnitAcronym: string = "";
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
	public UnitHeadPersonID?: number;
	public CommanderFirstName: string = "";
	public CommanderLastName: string = "";
	public UnitHeadJobTitle: string = "";
	public UnitHeadRankID?: number;
	public RankName: string = "";
	public UnitHeadRank: string = "";
	public UnitHeadFirstMiddleNames: string = "";
	public UnitHeadLastNames: string = "";
	public UnitHeadIDNumber: string = "";
	public UnitHeadGender?: string;
	public UnitHeadDOB?: Date;
	public UnitHeadPoliceMilSecID: string = "";
	public UnitHeadPOBCityID?: number;
	public UnitHeadResidenceCityID?: number;
	public UnitHeadContactEmail: string = "";
	public UnitHeadContactPhone: string = "";
	public UnitHeadHighestEducationID?: number;
	public UnitHeadEnglishLanguageProficiencyID?: number;
	public HQLocationID?: number;
	public POCName: string = "";
	public POCEmailAddress: string = "";
	public POCTelephone: string = "";
	public VettingPrefix: string = "";
	public HasDutyToInform: boolean = false;
	public IsLocked: boolean = false;
	public IsActive?: boolean;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public UnitParentJson: string = "";
	public CountryJson: string = "";
	public LocationJson: string = "";
	public PostJson: string = "";
	public MainAgencyJson: string = "";
	public HQLocationJson: string = "";
	public UnitAlias?: GetUnitAlias_Item[];
	public UnitLocation?: GetUnitLocation_Item;
	public HQLocation?: GetUnitLocation_Item;
	public Commander?: GetUnitCommander_Item;
  
}


