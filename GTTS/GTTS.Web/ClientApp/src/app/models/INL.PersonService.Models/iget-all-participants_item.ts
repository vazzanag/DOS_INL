



export interface IGetAllParticipants_Item {
  
	PersonID: number;
	CountryID?: number;
	FirstMiddleNames: string;
	Gender: string;
	AgencyName: string;
	RankName: string;
	JobTitle: string;
	LastVettingTypeCode: string;
	LastVettingStatusCode: string;
	LastVettingStatusDate?: Date;
	ParticipantType: string;
	Distinction: string;
	UnitName: string;
	VettingValidEndDate?: Date;
	TrainingDate?: Date;
	DOB?: Date;
	UnitNameEnglish: string;
	UnitAcronym: string;
	AgencyNameEnglish: string;
	NationalID: string;

}

