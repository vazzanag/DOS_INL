



export interface ISaveTrainingEventInstructor_Param {
  
	PersonID?: number;
	TrainingEventID?: number;
	PersonsVettingID?: number;
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
	RemovalCauseID?: number;
	DateCanceled?: Date;
	Comments: string;
}





