


import { IPersonLanguage_Item } from './iperson-language_item';

export interface ISaveTrainingEventParticipant_Result {
  
	PersonID?: number;
	TrainingEventID?: number;
	FirstMiddleNames: string;
	LastNames: string;
	Gender?: string;
	UnitID?: number;
	IsUSCitizen?: boolean;
	NationalID: string;
	ResidenceLocationID?: number;
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
	PoliceMilSecID: string;
	JobTitle: string;
	RankID?: number;
	YearsInPosition?: number;
	TrainingEventGroupID?: number;
	IsVIP?: boolean;
	IsParticipant?: boolean;
	IsTraveling?: boolean;
	DepartureCityID?: number;
	DepartureDate?: Date;
	ReturnDate?: Date;
	VettingStatusID?: number;
	VisaStatusID?: number;
	PaperworkStatusID?: number;
	TravelDocumentStatusID?: number;
	RemovedFromEvent?: boolean;
	RemovalReasonID?: number;
	RemovalReason: string;
	RemovalCauseID?: number;
	RemovalCause: string;
	DateCanceled?: Date;
	Comments: string;
	ModifiedByAppUserID?: number;
	PersonsUnitLibraryInfoID?: number;
	Languages?: IPersonLanguage_Item[];
}





