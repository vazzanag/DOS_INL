

import { ISearchVettingBatches_Item } from './isearch-vetting-batches_item';

export class SearchVettingBatches_Item implements ISearchVettingBatches_Item {
  
	public TrainingEventName: string = "";
	public TrainingNameInLocalLang: string = "";
	public TrainingEventID: number = 0;
	public FundingSourceCode: string = "";
	public FundingSource: string = "";
	public AuthorizingLawCode: string = "";
	public AuthorizingLaw: string = "";
	public VettingBatchType: string = "";
	public VettingBatchStatus: string = "";
	public VettingBatchID: number = 0;
	public VettingBatchName: string = "";
	public VettingBatchNumber: number = 0;
	public DateAccepted?: Date;
	public DateCourtesyCompleted?: Date;
	public DateLeahyResultsReceived?: Date;
	public DateSentToCourtesy?: Date;
	public DateSentToLeahy?: Date;
	public DateSubmitted?: Date;
	public DateVettingResultsNeededBy?: Date;
	public DateVettingResultsNotified?: Date;
	public GTTSTrackingNumber: string = "";
	public LeahyTrackingNumber: string = "";
	public INKTrackingNumber: string = "";
	public CountryID?: number;
	public AssignedToAppUserID?: number;
	public PersonsCount: number = 0;
	public EventStartDate?: Date;
  
}


