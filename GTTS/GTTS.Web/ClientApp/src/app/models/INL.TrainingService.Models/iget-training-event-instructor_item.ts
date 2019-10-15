


import { PersonLanguage_Item } from './person-language_item';

export interface IGetTrainingEventInstructor_Item {
  
	ParticipantID: number;
	PersonID: number;
	PersonsVettingID?: number;
	Ordinal: number;
	FirstMiddleNames: string;
	LastNames: string;
	Gender: string;
	UnitID: number;
	UnitName: string;
	UnitNameEnglish: string;
	UnitParentName: string;
	UnitParentNameEnglish: string;
	UnitTypeID: number;
	UnitType: string;
	AgencyName: string;
	AgencyNameEnglish: string;
	IsUSCitizen: boolean;
	NationalID: string;
	ResidenceCountryID: number;
	ResidenceStreetAddress: string;
	ResidenceStateID: number;
	ResidenceCityID: number;
	POBCountryID: number;
	POBStateID: number;
	POBCityID: number;
	DepartureCountryID: number;
	DepartureStateID: number;
	DepartureCityID: number;
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
	PoliceMilSecID: string;
	JobTitle: string;
	RankID?: number;
	RankName: string;
	YearsInPosition?: number;
	MedicalClearanceStatus?: boolean;
	MedicalClearanceDate?: Date;
	PsychologicalClearanceStatus?: boolean;
	PsychologicalClearanceDate?: Date;
	TrainingEventID: number;
	IsTraveling: boolean;
	DepartureCity: string;
	DepartureState: string;
	DepartureDate?: Date;
	ReturnDate?: Date;
	VettingStatusID?: number;
	VettingStatus: string;
	VisaStatusID?: number;
	VisaStatus: string;
	PaperworkStatusID?: number;
	TravelDocumentStatusID?: number;
	RemovedFromEvent: boolean;
	RemovalReasonID?: number;
	RemovalReason: string;
	RemovalCauseID?: number;
	RemovalCause: string;
	DateCanceled?: Date;
	Comments: string;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	IsVettingReq: boolean;
	IsLeahyVettingReq: boolean;
	IsArmedForces: boolean;
	IsLawEnforcement: boolean;
	IsSecurityIntelligence: boolean;
	IsValidated: boolean;
	Languages?: PersonLanguage_Item[];
}





