


import { GetUnitAlias_Item } from './get-unit-alias_item';
import { GetUnitLocation_Item } from './get-unit-location_item';
import { GetUnitCommander_Item } from './get-unit-commander_item';

export interface IUnit_Item {
  
	UnitID: number;
	UnitParentID?: number;
	UnitParentName: string;
	UnitParentNameEnglish: string;
	AgencyName: string;
	AgencyNameEnglish: string;
	UnitAgencyName: string;
	UnitParents: string;
	UnitBreakdown: string;
	UnitBreakdownLocalLang: string;
	CountryID: number;
	CountryName: string;
	UnitLocationID?: number;
	ConsularDistrictID?: number;
	UnitName: string;
	UnitNameEnglish: string;
	IsMainAgency: boolean;
	UnitMainAgencyID?: number;
	UnitAcronym: string;
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
	UnitHeadPersonID?: number;
	CommanderFirstName: string;
	CommanderLastName: string;
	UnitHeadJobTitle: string;
	UnitHeadRankID?: number;
	RankName: string;
	UnitHeadRank: string;
	UnitHeadFirstMiddleNames: string;
	UnitHeadLastNames: string;
	UnitHeadIDNumber: string;
	UnitHeadGender?: string;
	UnitHeadDOB?: Date;
	UnitHeadPoliceMilSecID: string;
	UnitHeadPOBCityID?: number;
	UnitHeadResidenceCityID?: number;
	UnitHeadContactEmail: string;
	UnitHeadContactPhone: string;
	UnitHeadHighestEducationID?: number;
	UnitHeadEnglishLanguageProficiencyID?: number;
	HQLocationID?: number;
	POCName: string;
	POCEmailAddress: string;
	POCTelephone: string;
	VettingPrefix: string;
	HasDutyToInform: boolean;
	IsLocked: boolean;
	IsActive?: boolean;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	UnitParentJson: string;
	CountryJson: string;
	LocationJson: string;
	PostJson: string;
	MainAgencyJson: string;
	HQLocationJson: string;
	UnitAlias?: GetUnitAlias_Item[];
	UnitLocation?: GetUnitLocation_Item;
	HQLocation?: GetUnitLocation_Item;
	Commander?: GetUnitCommander_Item;

}

