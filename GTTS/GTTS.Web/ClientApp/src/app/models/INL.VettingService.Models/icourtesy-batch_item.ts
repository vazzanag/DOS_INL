



export interface ICourtesyBatch_Item {
  
	CourtesyBatchID: number;
	VettingBatchID: number;
	VettingTypeID: number;
	VettingType: string;
	VettingBatchNotes: string;
	AssignedToAppUserID?: number;
	AssignedToAppUserName: string;
	ResultsSubmittedDate?: Date;
	ResultsSubmittedByAppUserID?: number;
	ResultsSubmittedByAppUserName: string;

}

