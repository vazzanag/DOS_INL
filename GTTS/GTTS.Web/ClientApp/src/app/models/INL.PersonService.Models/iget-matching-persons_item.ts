



export interface IGetMatchingPersons_Item {
  
	PersonID: number;
	FirstMiddleNames: string;
	LastNames: string;
	DOB?: Date;
	POBCityID?: number;
	IsUSCitizen: boolean;
	ResidenceLocationID?: number;
	ContactEmail: string;
	ContactPhone: string;
	HighestEducationID?: number;
	EnglishLanguageProficiencyID?: number;
	PassportNumber: string;
	PassportExpirationDate?: Date;
	PassportIssuingCountryID?: number;
	MatchCompletely: number;
	Gender?: string;
	NationalID: string;
	POBCityName: string;
	POBStateName: string;
	POBCountryName: string;
	PersonLanguagesJSON: string;
	UnitID: number;
	RankID?: number;
	UnitMainAgencyID?: number;
	IsLeahyVettingReq: boolean;
	IsVettingReq: boolean;
	IsValidated: boolean;
	HostNationPOCEmail: string;
	HostNationPOCName: string;
	PoliceMilSecID: string;
	JobTitle: string;
	YearsInPosition?: number;
	MedicalClearanceStatus?: boolean;
	IsUnitCommander?: boolean;

}

