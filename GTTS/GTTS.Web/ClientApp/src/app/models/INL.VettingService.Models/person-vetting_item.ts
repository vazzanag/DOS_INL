

import { IPersonVetting_Item } from './iperson-vetting_item';

export class PersonVetting_Item implements IPersonVetting_Item {
  
	public PersonsVettingID: number = 0;
	public PersonsUnitLibraryInfoID: number = 0;
	public PersonID: number = 0;
	public GivenName: string = "";
	public MiddleName1: string = "";
	public MiddleName2: string = "";
	public MiddleName3: string = "";
	public FamilyName: string = "";
	public Name1: string = "";
	public Name2: string = "";
	public Name3: string = "";
	public Name4: string = "";
	public Name5: string = "";
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public POBCountryINKCode: string = "";
	public POBStateINKCode: string = "";
	public DOB?: Date;
	public Gender: string = "";
	public NationalID: string = "";
	public POBCityID?: number;
	public POBCityName: string = "";
	public POBStateID?: number;
	public POBStateName: string = "";
	public POBCountryID?: number;
	public POBCountryName: string = "";
	public UnitID?: number;
	public UnitName: string = "";
	public UnitGenID: string = "";
	public UnitAgencyName: string = "";
	public UnitParents: string = "";
	public UnitParentsEnglish: string = "";
	public UnitBreakdownLocalLang: string = "";
	public UnitAcronym: string = "";
	public JobTitle: string = "";
	public RankName: string = "";
	public VettingBatchID: number = 0;
	public VettingPersonStatusID: number = 0;
	public VettingStatus: string = "";
	public VettingStatusDate?: Date;
	public VettingNotes: string = "";
	public ClearedDate?: Date;
	public AppUserIDCleared?: number;
	public DeniedDate?: Date;
	public AppUserIDDenied?: number;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public LastVettingStatusID?: number;
	public LastVettingStatusCode: string = "";
	public LastVettingStatusDate?: Date;
	public LastVettingTypeID?: number;
	public LastVettingTypeCode: string = "";
	public ParticipantID: number = 0;
	public ParticipantType: string = "";
	public IsRemoved: boolean = false;
	public RemovedFromEvent: boolean = false;
	public RemovedFromVetting: boolean = false;
	public LeahyHitResultCode: string = "";
	public VettingActivityType: string = "";
	public IsReVetting: boolean = false;
  
}


