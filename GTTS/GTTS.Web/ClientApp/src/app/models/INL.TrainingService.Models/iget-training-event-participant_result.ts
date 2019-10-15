


import { PersonLanguage_Item } from './person-language_item';

export interface IGetTrainingEventParticipant_Result {
  
	ParticipantID: number;
	PersonID: number;
	PersonsVettingID: number;
	ParticipantType: string;
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
	UnitMainAgencyID?: number;
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
	PassportIssuingCountryID?: number;
	PoliceMilSecID: string;
	HostNationPOCName: string;
	HostNationPOCEmail: string;
	JobTitle: string;
	RankID?: number;
	RankName: string;
	YearsInPosition?: number;
	MedicalClearanceStatus?: boolean;
	MedicalClearanceDate?: Date;
	PsychologicalClearanceStatus?: boolean;
	PsychologicalClearanceDate?: Date;
	TrainingEventID: number;
	GroupName: string;
	IsVIP: boolean;
	IsParticipant: boolean;
	IsTraveling: boolean;
	DepartureCity: string;
	DepartureState: string;
	DepartureDate?: Date;
	ReturnDate?: Date;
	VettingStatusID?: number;
	VettingBatchStatus: string;
	VettingBatchTypeID?: number;
	VettingTrainingEventID?: number;
	VettingTrainingEventName: string;
	VettingBatchStatusID?: number;
	VettingBatchType: string;
	VettingStatusDate?: Date;
	VisaStatusID?: number;
	VisaStatus: string;
	PaperworkStatusID?: number;
	TravelDocumentStatusID?: number;
	RemovedFromEvent: boolean;
	RemovalReasonID?: number;
	RemovalReason: string;
	RemovalCauseID?: number;
	RemovalCause: string;
	TrainingEventRosterDistinction: string;
	DateCanceled?: Date;
	Comments: string;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	HasLocalGovTrust: boolean;
	PassedLocalGovTrust?: boolean;
	LocalGovTrustCertDate?: Date;
	OtherVetting: boolean;
	PassedOtherVetting?: boolean;
	OtherVettingDescription: string;
	OtherVettingDate?: Date;
	IsVettingReq: boolean;
	IsLeahyVettingReq: boolean;
	IsArmedForces: boolean;
	IsLawEnforcement: boolean;
	IsSecurityIntelligence: boolean;
	IsValidated: boolean;
	PersonsUnitLibraryInfoID?: number;
	IsUnitCommander?: boolean;
	Languages?: PersonLanguage_Item[];
}





