



export interface IPersonVetting_Item {
  
	PersonsVettingID: number;
	PersonsUnitLibraryInfoID: number;
	PersonID: number;
	Name1: string;
	Name2: string;
	Name3: string;
	Name4: string;
	Name5: string;
	FirstMiddleNames: string;
	LastNames: string;
	DOB?: Date;
	Gender: string;
	NationalID: string;
	POBCityID?: number;
	POBCityName: string;
	POBStateID?: number;
	POBStateName: string;
	POBStateINKCode: string;
	POBCountryID?: number;
	POBCountryName: string;
	POBCountryINKCode: string;
	UnitID?: number;
	UnitName: string;
	UnitGenID: string;
	UnitAgencyName: string;
	UnitParents: string;
	UnitParentsEnglish: string;
	UnitBreakdownLocalLang: string;
	UnitAcronym: string;
	JobTitle: string;
	RankName: string;
	VettingBatchID: number;
	VettingPersonStatusID: number;
	VettingStatus: string;
	VettingStatusDate?: Date;
	VettingNotes: string;
	ClearedDate?: Date;
	AppUserIDCleared?: number;
	DeniedDate?: Date;
	AppUserIDDenied?: number;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	LastVettingStatusID?: number;
	LastVettingStatusCode: string;
	LastVettingStatusDate?: Date;
	LastVettingTypeID?: number;
	LastVettingTypeCode: string;
	ParticipantID: number;
	ParticipantType: string;
	IsRemoved: boolean;
	RemovedFromEvent: boolean;
	RemovedFromVetting: boolean;
	LeahyHitResultCode: string;
	VettingActivityType: string;
	IsReVetting: boolean;

}

