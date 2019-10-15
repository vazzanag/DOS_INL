



export interface ISearchVettingBatches_Item {
  
	TrainingEventName: string;
	TrainingNameInLocalLang: string;
	TrainingEventID: number;
	FundingSourceCode: string;
	FundingSource: string;
	AuthorizingLawCode: string;
	AuthorizingLaw: string;
	VettingBatchType: string;
	VettingBatchStatus: string;
	VettingBatchID: number;
	VettingBatchName: string;
	VettingBatchNumber: number;
	DateAccepted?: Date;
	DateCourtesyCompleted?: Date;
	DateLeahyResultsReceived?: Date;
	DateSentToCourtesy?: Date;
	DateSentToLeahy?: Date;
	DateSubmitted?: Date;
	DateVettingResultsNeededBy?: Date;
	DateVettingResultsNotified?: Date;
	GTTSTrackingNumber: string;
	LeahyTrackingNumber: string;
	INKTrackingNumber: string;
	CountryID?: number;
	AssignedToAppUserID?: number;
	PersonsCount: number;
	EventStartDate?: Date;

}

