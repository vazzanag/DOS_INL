


import { IPersonLanguage_Item } from './iperson-language_item';

export interface ISavePerson_Param {
  
	PersonID?: number;
	PersonsUnitLibraryInfoID?: number;
	FirstMiddleNames: string;
	LastNames: string;
	Gender: string;
	UnitID?: number;
	IsUSCitizen: boolean;
	NationalID: string;
	ResidenceLocationID?: number;
	ResidenceCityID?: number;
	ResidenceStreetAddress: string;
	ContactEmail: string;
	ContactPhone: string;
	DOB?: Date;
	POBCityID?: number;
	FatherName: string;
	MotherName: string;
	HighestEducationID?: number;
	FamilyIncome?: number;
	EnglishLanguageProficiencyID?: number;
	PassportNumber: string;
	PassportExpirationDate?: Date;
	PassportIssuingCountryID?: number;
	PoliceMilSecID: string;
	HostNationPOCName: string;
	HostNationPOCEmail: string;
	JobTitle: string;
	RankID?: number;
	YearsInPosition?: number;
	IsUnitCommander?: boolean;
	MedicalClearanceStatus?: boolean;
	HasLocalGovTrust?: boolean;
	LocalGovTrustCertDate?: Date;
	IsVettingReq?: boolean;
	IsLeahyVettingReq?: boolean;
	IsArmedForces?: boolean;
	IsLawEnforcement?: boolean;
	IsSecurityIntelligence?: boolean;
	IsValidated?: boolean;
	MedicalClearanceDate?: Date;
	DentalClearanceStatus?: boolean;
	DentalClearanceDate?: Date;
	PsychologicalClearanceStatus?: boolean;
	PsychologicalClearanceDate?: Date;
	Languages?: IPersonLanguage_Item[];

}

