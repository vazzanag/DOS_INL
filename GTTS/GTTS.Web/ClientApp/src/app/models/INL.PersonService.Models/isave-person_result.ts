


import { PersonLanguage_Item } from './person-language_item';

export interface ISavePerson_Result {
  
	PersonID?: number;
	FirstMiddleNames: string;
	LastNames: string;
	Gender: string;
	UnitID?: number;
	IsUSCitizen: boolean;
	NationalID: string;
	ResidenceStreetAddress: string;
	ResidenceCityID?: number;
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
	LawPoliceMilitaryID: string;
	Rank?: number;
	YearsInCurrentPosition?: number;
	MedicalClearanceStatus?: boolean;
	MedicalClearanceDate?: Date;
	DentalClearanceStatus?: boolean;
	DentalClearanceDate?: Date;
	PsychologicalClearanceStatus?: boolean;
	PsychologicalClearanceDate?: Date;
	ModifiedByAppUserID?: number;
	Languages?: PersonLanguage_Item[];

}

