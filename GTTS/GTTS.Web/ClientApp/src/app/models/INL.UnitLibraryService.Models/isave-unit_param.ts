


import { SaveUnitAlias_Item } from './save-unit-alias_item';
import { SaveUnitLocation_Item } from './save-unit-location_item';
import { SaveUnitCommander_Item } from './save-unit-commander_item';

export interface ISaveUnit_Param {
  
	UnitID?: number;
	UnitParentID?: number;
	CountryID: number;
	UnitLocationID?: number;
	ConsularDistrictID?: number;
	UnitName: string;
	UnitNameEnglish: string;
	IsMainAgency?: boolean;
	UnitMainAgencyID?: number;
	UnitAcronym: string;
	UnitGenID: string;
	UnitAlias?: SaveUnitAlias_Item[];
	UnitTypeID: number;
	GovtLevelID?: number;
	UnitLevelID?: number;
	VettingBatchTypeID: number;
	VettingActivityTypeID: number;
	ReportingTypeID?: number;
	UnitHeadPersonID?: number;
	UnitHeadJobTitle: string;
	UnitHeadRankID?: number;
	HQLocationID?: number;
	POCName: string;
	POCEmailAddress: string;
	POCTelephone: string;
	VettingPrefix: string;
	HasDutyToInform: boolean;
	IsLocked: boolean;
	IsActive: boolean;
	ModifiedDate?: Date;
	UnitLocation?: SaveUnitLocation_Item;
	HQLocation?: SaveUnitLocation_Item;
	Commander?: SaveUnitCommander_Item;

}

