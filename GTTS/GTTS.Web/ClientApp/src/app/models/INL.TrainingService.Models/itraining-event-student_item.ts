



export interface ITrainingEventStudent_Item {
  
	PersonID: number;
	TrainingEventID: number;
	IsVIP?: boolean;
	IsParticipant?: boolean;
	IsTraveling?: boolean;
	DepartureCityID?: number;
	DepartureDate?: Date;
	ReturnDate?: Date;
	VisaStatusID?: number;
	HasLocalGovTrust?: boolean;
	LocalGovTrustCertDate?: Date;
	OtherVetting?: boolean;
	PassedOtherVetting?: boolean;
	OtherVettingDescription: string;
	OtherVettingDate?: Date;
	PaperworkStatusID?: number;
	TravelDocumentStatusID?: number;
	RemovedFromEvent: boolean;
	RemovalReasonID?: number;
	RemovalCauseID?: number;
	DateCanceled?: Date;
	Comments: string;
	ModifiedByAppUserID?: number;
}





