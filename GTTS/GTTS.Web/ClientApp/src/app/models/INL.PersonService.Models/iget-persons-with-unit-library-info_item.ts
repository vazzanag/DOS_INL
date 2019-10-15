



export interface IGetPersonsWithUnitLibraryInfo_Item {
  
	PersonID: number;
	FirstMiddleNames: string;
	LastNames: string;
	Gender: string;
	IsUSCitizen: boolean;
	NationalID: string;
	ResidenceLocationID?: number;
	ResidenceStreetAddress: string;
	ResidenceCityID?: number;
	ResidenceStateID?: number;
	ResidenceCountryID?: number;
	POBCityID?: number;
	POBStateID?: number;
	POBCountryID?: number;
	ContactEmail: string;
	ContactPhone: string;
	DOB?: Date;
	FatherName: string;
	MotherName: string;
	HighestEducationID?: number;
	FamilyIncome?: number;
	EnglishLanguageProficiencyID?: number;
	PassportNumber: string;
	PassportExpirationDate?: Date;
	PassportIssuingCountryID?: number;
	MedicalClearanceStatus?: boolean;
	MedicalClearanceDate?: Date;
	PsychologicalClearanceStatus?: boolean;
	PsychologicalClearanceDate?: Date;
	UnitID?: number;
	UnitName: string;
	UnitNameEnglish: string;
	JobTitle: string;
	YearsInPosition?: number;
	WorkEmailAddress: string;
	RankID?: number;
	RankName: string;
	IsUnitCommander?: boolean;
	PoliceMilSecID: string;
	HostNationPOCName: string;
	HostNationPOCEmail: string;
	HasLocalGovTrust?: boolean;
	LocalGovTrustCertDate?: Date;
	IsVettingReq?: boolean;
	IsLeahyVettingReq?: boolean;
	IsArmedForces?: boolean;
	IsLawEnforcement?: boolean;
	IsSecurityIntelligence?: boolean;
	IsValidated?: boolean;
	IsInVettingProcess?: boolean;
	ModifiedByAppUserID: number;
	PersonLanguagesJSON: string;

}

