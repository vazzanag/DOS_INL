



export interface ISaveTrainingEventParticipant_Param {
  
	PersonID?: number;
	TrainingEventID?: number;
	ParticipantType: string;
	FirstMiddleNames: string;
	LastNames: string;
	Gender?: string;
	UnitID?: number;
	IsUSCitizen?: boolean;
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
	LawPoliceMilitaryID: string;
	JobTitleID?: number;
	RankID?: number;
	YearsInCurrentPosition?: number;
	TrainingEventGroupID?: number;
	IsVIP?: boolean;
	IsParticipant?: boolean;
	IsTraveling?: boolean;
	DepartureCityID?: number;
	DepartureDate?: Date;
	ReturnDate?: Date;
	VettingStatusID?: number;
	VisaStatusID?: number;
	HasLocalGovTrust?: boolean;
	LocalGovTrustCertDate?: Date;
	OtherVetting?: boolean;
	PassedOtherVetting: boolean;
	OtherVettingDescription: string;
	OtherVettingDate?: Date;
	PaperworkStatusID?: number;
	TravelDocumentStatusID?: number;
	RemovedFromEvent?: boolean;
	RemovalReasonID?: number;
	RemovalCauseID?: number;
	DateCanceled?: Date;
	Comments: string;
}





