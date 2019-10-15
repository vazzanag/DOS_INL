

import { ICourtesyBatch_Item } from './icourtesy-batch_item';
import { IPersonVetting_Item } from './iperson-vetting_item';
import { IPersonVettingType_Item } from './iperson-vetting-type_item';
import { IPersonVettingHit_Item } from './iperson-vetting-hit_item';
import { IPersonVettingVettingType_Item } from './iperson-vetting-vetting-type_item';
import { IVettingBatch_Item } from './ivetting-batch_item';

export class VettingBatch_Item implements IVettingBatch_Item {
  
	public Ordinal: number = 0;
	public VettingBatchID: number = 0;
	public VettingBatchName: string = "";
	public VettingBatchNumber: number = 0;
	public VettingBatchOrdinal: number = 0;
	public TrainingEventID?: number;
	public CountryID?: number;
	public CountryName: string = "";
	public VettingBatchTypeID: number = 0;
	public VettingBatchType: string = "";
	public AssignedToAppUserID?: number;
	public AssignedToAppUserFirstName: string = "";
	public AssignedToAppUserLastName: string = "";
	public VettingBatchStatusID: number = 0;
	public VettingBatchStatus: string = "";
	public IsCorrectionRequired: boolean = false;
	public CourtesyVettingOverrideFlag?: boolean;
	public CourtesyVettingOverrideReason: string = "";
	public GTTSTrackingNumber: string = "";
	public LeahyTrackingNumber: string = "";
	public INKTrackingNumber: string = "";
	public DateVettingResultsNeededBy?: Date;
	public DateSubmitted?: Date;
	public DateAccepted?: Date;
	public DateSentToCourtesy?: Date;
	public DateCourtesyCompleted?: Date;
	public DateSentToLeahy?: Date;
	public DateLeahyResultsReceived?: Date;
	public DateVettingResultsNotified?: Date;
	public EventStartDate?: Date;
	public DateLeahyFileGenerated?: Date;
	public VettingFundingSourceID: number = 0;
	public VettingFundingSource: string = "";
	public AuthorizingLawID: number = 0;
	public AuthorizingLaw: string = "";
	public VettingBatchNotes: string = "";
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public TrainingEventName: string = "";
	public TrainingEventBusinessUnitAcronym: string = "";
	public HasHits: boolean = false;
	public TotalHits: number = 0;
	public SubmittedAppUserFirstName: string = "";
	public SubmittedAppUserLastName: string = "";
	public AcceptedAppUserFirstName: string = "";
	public AcceptedAppUserLastName: string = "";
	public CourtesyCompleteAppUserFirstName: string = "";
	public CourtesyCompleteAppUserLastName: string = "";
	public SentToCourtesyAppUserFirstName: string = "";
	public SentToCourtesyAppUserLastName: string = "";
	public SentToLeahyAppUserFirstName: string = "";
	public SentToLeahyAppUserLastName: string = "";
	public FileID: number = 0;
	public NumOfRemovedParticipants: number = 0;
	public NumOfCanceledParticipants: number = 0;
	public CourtesyBatch?: ICourtesyBatch_Item;
	public PersonVettings?: IPersonVetting_Item[];
	public PersonVettingTypes?: IPersonVettingType_Item[];
	public PersonVettingHits?: IPersonVettingHit_Item[];
	public PersonVettingVettingTypes?: IPersonVettingVettingType_Item[];
  
}


