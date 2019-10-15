


import { PersonLanguage_Item } from './person-language_item';

export interface ISaveTrainingEventPersonParticipant_Param {
  
	ParticipantID?: number;
	PersonID?: number;
	ParticipantType: string;
	FirstMiddleNames: string;
	LastNames: string;
	Gender: string;
	UnitID: number;
	IsUSCitizen: boolean;
	NationalID: string;
	ResidenceStreetAddress: string;
	ResidenceCityID?: number;
	ContactEmail: string;
	ContactPhone: string;
	DOB?: Date;
	POBCityID?: number;
	POBStateID?: number;
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
	MedicalClearanceStatus?: boolean;
	MedicalClearanceDate?: Date;
	DentalClearanceStatus?: boolean;
	DentalClearanceDate?: Date;
	PsychologicalClearanceStatus?: boolean;
	PsychologicalClearanceDate?: Date;
	TrainingEventID?: number;
	TrainingEventGroupID?: number;
	IsVIP?: boolean;
	IsParticipant?: boolean;
	IsTraveling?: boolean;
	DepartureCityID?: number;
	DepartureDate?: Date;
	ReturnDate?: Date;
	VettingStatusID?: number;
	VettingPersonStatusID?: number;
	VisaStatusID?: number;
	HasLocalGovTrust: boolean;
	PassedLocalGovTrust?: boolean;
	LocalGovTrustCertDate?: Date;
	OtherVetting: boolean;
	PassedOtherVetting?: boolean;
	OtherVettingDescription: string;
	OtherVettingDate?: Date;
	PaperworkStatusID?: number;
	TravelDocumentStatusID?: number;
	RemovedFromEvent?: boolean;
	ReasonRemoved: string;
	ReasonSpecific: string;
	DateCanceled?: Date;
	Comments: string;
	IsVettingReq: boolean;
	IsLeahyVettingReq: boolean;
	IsArmedForces: boolean;
	IsLawEnforcement: boolean;
	IsSecurityIntelligence: boolean;
	IsValidated: boolean;
	ExactMatch?: boolean;
	IsUnitCommander?: boolean;
	Languages?: PersonLanguage_Item[];
}





