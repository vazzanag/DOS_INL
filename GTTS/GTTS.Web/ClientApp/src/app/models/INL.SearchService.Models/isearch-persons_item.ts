



export interface ISearchPersons_Item {
  
	PersonID: number;
	FirstMiddleNames: string;
	LastNames: string;
	ParticipantType: string;
	VettingStatus: string;
	VettingStatusDate?: Date;
	VettingTypeCode: string;
	UnitID?: number;
	UnitName: string;
	UnitNameEnglish: string;
	AgencyName: string;
	AgencyNameEnglish: string;
	DOB?: Date;
	Distinction: string;
	Gender: string;
	JobRank: string;
	JobTitle: string;
	CountryID?: number;
	CountryName: string;
	VettingValidEndDate?: Date;
	RowNumber: number;

}

