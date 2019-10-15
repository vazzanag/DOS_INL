



export interface ISearchParticipants_Item {
  
	ParticipantType: string;
	PersonID: number;
	FirstMiddleNames: string;
	LastNames: string;
	DOB?: Date;
	Gender?: string;
	JobTitle: string;
	JobRank: string;
	CountryID?: number;
	CountryName: string;
	CountryFullName: string;
	UnitID?: number;
	UnitName: string;
	UnitNameEnglish: string;
	UnitMainAgencyID?: number;
	AgencyName: string;
	AgencyNameEnglish: string;
	VettingStatus: string;
	VettingStatusDate?: Date;
	VettingType: string;
	Distinction: string;
	EventStartDate?: Date;
	TrainingEventID: number;
	TrainingEventParticipantID: number;
	IsParticipant?: boolean;
	RemovedFromEvent: boolean;
	DepartureCity: string;
	DepartureDate?: Date;
	ReturnDate?: Date;
	PersonsVettingID?: number;
	IsTraveling: boolean;
	OnboardingComplete?: boolean;
	VisaStatusID?: number;
	VisaStatus: string;
	ContactEmail: string;
	IsUSCitizen?: boolean;
	TrainingEventGroupID?: number;
	GroupName: string;
	VettingPersonStatusID?: number;
	VettingPersonStatus: string;
	VettingPersonStatusDate?: Date;
	VettingBatchTypeID?: number;
	VettingBatchType: string;
	VettingBatchStatusID?: number;
	VettingBatchStatus: string;
	VettingBatchStatusDate?: Date;
	RemovedFromVetting?: boolean;
	VettingTrainingEventName: string;
	IsLeahyVettingReq?: boolean;
	IsVettingReq?: boolean;
	IsValidated?: boolean;
	PersonsUnitLibraryInfoID?: number;
	NationalID: string;
	UnitTypeID?: number;
	UnitAcronym: string;
	UnitParentName: string;
	UnitParentNameEnglish: string;
	UnitType: string;
	DocumentCount?: number;
	CourtesyVettingsJSON: string;

}

