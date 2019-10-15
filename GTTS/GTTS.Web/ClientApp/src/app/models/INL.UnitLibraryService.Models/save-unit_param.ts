

import { SaveUnitAlias_Item } from './save-unit-alias_item';
import { SaveUnitLocation_Item } from './save-unit-location_item';
import { SaveUnitCommander_Item } from './save-unit-commander_item';
import { ISaveUnit_Param } from './isave-unit_param';

export class SaveUnit_Param implements ISaveUnit_Param {
  
	public UnitID?: number;
	public UnitParentID?: number;
	public CountryID: number = 0;
	public UnitLocationID?: number;
	public ConsularDistrictID?: number;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public IsMainAgency?: boolean;
	public UnitMainAgencyID?: number;
	public UnitAcronym: string = "";
	public UnitGenID: string = "";
	public UnitAlias?: SaveUnitAlias_Item[];
	public UnitTypeID: number = 0;
	public GovtLevelID?: number;
	public UnitLevelID?: number;
	public VettingBatchTypeID: number = 0;
	public VettingActivityTypeID: number = 0;
	public ReportingTypeID?: number;
	public UnitHeadPersonID?: number;
	public UnitHeadJobTitle: string = "";
	public UnitHeadRankID?: number;
	public HQLocationID?: number;
	public POCName: string = "";
	public POCEmailAddress: string = "";
	public POCTelephone: string = "";
	public VettingPrefix: string = "";
	public HasDutyToInform: boolean = false;
	public IsLocked: boolean = false;
	public IsActive: boolean = false;
	public ModifiedDate?: Date;
	public UnitLocation?: SaveUnitLocation_Item;
	public HQLocation?: SaveUnitLocation_Item;
	public Commander?: SaveUnitCommander_Item;
  
}


