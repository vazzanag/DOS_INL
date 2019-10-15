


import { ICourtesyBatch_Item } from './icourtesy-batch_item';
import { IPersonVetting_Item } from './iperson-vetting_item';
import { IPersonVettingType_Item } from './iperson-vetting-type_item';
import { IPersonVettingHit_Item } from './iperson-vetting-hit_item';
import { IPersonVettingVettingType_Item } from './iperson-vetting-vetting-type_item';

export interface IVettingBatch_Item {
  
	Ordinal: number;
	VettingBatchID: number;
	VettingBatchName: string;
	VettingBatchNumber: number;
	VettingBatchOrdinal: number;
	TrainingEventID?: number;
	CountryID?: number;
	CountryName: string;
	VettingBatchTypeID: number;
	VettingBatchType: string;
	AssignedToAppUserID?: number;
	AssignedToAppUserFirstName: string;
	AssignedToAppUserLastName: string;
	VettingBatchStatusID: number;
	VettingBatchStatus: string;
	IsCorrectionRequired: boolean;
	CourtesyVettingOverrideFlag?: boolean;
	CourtesyVettingOverrideReason: string;
	GTTSTrackingNumber: string;
	LeahyTrackingNumber: string;
	INKTrackingNumber: string;
	DateVettingResultsNeededBy?: Date;
	DateSubmitted?: Date;
	DateAccepted?: Date;
	DateSentToCourtesy?: Date;
	DateCourtesyCompleted?: Date;
	DateSentToLeahy?: Date;
	DateLeahyResultsReceived?: Date;
	DateVettingResultsNotified?: Date;
	EventStartDate?: Date;
	DateLeahyFileGenerated?: Date;
	VettingFundingSourceID: number;
	VettingFundingSource: string;
	AuthorizingLawID: number;
	AuthorizingLaw: string;
	VettingBatchNotes: string;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	TrainingEventName: string;
	TrainingEventBusinessUnitAcronym: string;
	HasHits: boolean;
	SubmittedAppUserFirstName: string;
	SubmittedAppUserLastName: string;
	AcceptedAppUserFirstName: string;
	AcceptedAppUserLastName: string;
	CourtesyCompleteAppUserFirstName: string;
	CourtesyCompleteAppUserLastName: string;
	SentToCourtesyAppUserFirstName: string;
	SentToCourtesyAppUserLastName: string;
	SentToLeahyAppUserFirstName: string;
	SentToLeahyAppUserLastName: string;
	FileID: number;
	NumOfRemovedParticipants: number;
	NumOfCanceledParticipants: number;
	CourtesyBatch?: ICourtesyBatch_Item;
	PersonVettings?: IPersonVetting_Item[];
	PersonVettingTypes?: IPersonVettingType_Item[];
	PersonVettingHits?: IPersonVettingHit_Item[];
	PersonVettingVettingTypes?: IPersonVettingVettingType_Item[];

}

