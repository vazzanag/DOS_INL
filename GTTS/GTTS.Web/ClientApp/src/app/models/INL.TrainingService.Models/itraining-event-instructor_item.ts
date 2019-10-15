



export interface ITrainingEventInstructor_Item {
  
	PersonID: number;
	TrainingEventID: number;
	PersonsVettingID?: number;
	IsTraveling: boolean;
	DepartureCityID?: number;
	DepartureDate?: Date;
	ReturnDate?: Date;
	VisaStatusID?: number;
	PaperworkStatusID?: number;
	TravelDocumentStatusID?: number;
	RemovedFromEvent: boolean;
	RemovalReasonID?: number;
	RemovalCauseID?: number;
	DateCanceled?: Date;
	Comments: string;
	ModifiedByAppUserID?: number;
}





