
import { VettingBatchParticipant } from '@models/vetting-batch-participant';
import { IVettingBatch_Item } from '@models/INL.VettingService.Models/ivetting-batch_item';
import { IPersonVetting_Item } from '@models/INL.VettingService.Models/iperson-vetting_item';

export class VettingBatch {

    public Ordinal: number = 0;
    public VettingBatchID: number = 0;
    public VettingBatchName: string = "";
    public VettingBatchNumber: number = 0;
    public TrainingEventID?: number;
    public CountryID?: number;
    public VettingBatchTypeID: number = 0;
    public VettingBatchType: string = "";
    public HasBeenAccepted: boolean = false;
    public AssignedToAppUserID?: number;
    public AssignedToAppUserFirstName: string = "";
    public AssignedToAppUserLastName: string = "";
    public VettingBatchStatusID?: number;
    public VettingBatchStatus: string = "";
    public IsCorrectionRequired?: boolean;
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
    public VettingFundingSourceID: number = 0;
    public VettingFundingSource: string = "";
    public AuthorizingLawID: number = 0;
    public AuthorizingLaw: string = "";
    public VettingBatchNotes: string = "";
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);

    public get AssignedToAppUserFullName(): string {
        return `${this.AssignedToAppUserFirstName} ${this.AssignedToAppUserLastName}`;
    }

    public Participants?: VettingBatchParticipant[] = [];



    public static FromIVettingBatch_Item(src: IVettingBatch_Item): VettingBatch {
        var result = new VettingBatch();

        result.Ordinal = src.Ordinal;
        result.VettingBatchID = src.VettingBatchID;
        result.VettingBatchName = src.VettingBatchName;
        result.VettingBatchNumber = src.VettingBatchNumber;
        result.TrainingEventID = src.TrainingEventID;
        result.CountryID = src.CountryID;
        result.VettingBatchTypeID = src.VettingBatchTypeID;
        result.VettingBatchType = src.VettingBatchType;
        result.AssignedToAppUserID = src.AssignedToAppUserID;
        result.AssignedToAppUserFirstName = src.AssignedToAppUserFirstName;
        result.AssignedToAppUserLastName = src.AssignedToAppUserLastName;
        result.VettingBatchStatusID = src.VettingBatchStatusID;
        result.VettingBatchStatus = src.VettingBatchStatus;
        result.IsCorrectionRequired = src.IsCorrectionRequired;
        result.CourtesyVettingOverrideFlag = src.CourtesyVettingOverrideFlag;
        result.CourtesyVettingOverrideReason = src.CourtesyVettingOverrideReason;
        result.GTTSTrackingNumber = src.GTTSTrackingNumber;
        result.LeahyTrackingNumber = src.LeahyTrackingNumber;
        result.INKTrackingNumber = src.INKTrackingNumber;
        result.DateVettingResultsNeededBy = src.DateVettingResultsNeededBy;
        result.DateSubmitted = src.DateSubmitted;
        result.DateAccepted = src.DateAccepted;
        result.DateSentToCourtesy = src.DateSentToCourtesy;
        result.DateCourtesyCompleted = src.DateCourtesyCompleted;
        result.DateSentToLeahy = src.DateSentToLeahy;
        result.DateLeahyResultsReceived = src.DateLeahyResultsReceived;
        result.DateVettingResultsNotified = src.DateVettingResultsNotified;
        result.EventStartDate = src.EventStartDate;
        result.VettingFundingSourceID = src.VettingFundingSourceID;
        result.VettingFundingSource = src.VettingFundingSource;
        result.AuthorizingLawID = src.AuthorizingLawID;
        result.AuthorizingLaw = src.AuthorizingLaw;
        result.VettingBatchNotes = src.VettingBatchNotes;
        result.ModifiedByAppUserID = src.ModifiedByAppUserID;
        result.ModifiedDate = src.ModifiedDate;

        result.HasBeenAccepted = src.VettingBatchStatusID > 1;
        src.PersonVettings.forEach(p => {
            var participant = VettingBatchParticipant.FromIPersonVetting_Item(p);
            result.Participants.push(participant);
            participant.Ordinal = result.Participants.length;
        });

        return result;
    }



    public static ToIVettingBatch_Item(src: VettingBatch): IVettingBatch_Item {
        var result = <IVettingBatch_Item>{};
        
        result.Ordinal = src.Ordinal;
        result.VettingBatchID = src.VettingBatchID;
        result.VettingBatchName = src.VettingBatchName;
        result.VettingBatchNumber = src.VettingBatchNumber;
        result.TrainingEventID = src.TrainingEventID;
        result.CountryID = src.CountryID;
        result.VettingBatchTypeID = src.VettingBatchTypeID;
        result.VettingBatchType = src.VettingBatchType;
        result.AssignedToAppUserID = src.AssignedToAppUserID;
        result.AssignedToAppUserFirstName = src.AssignedToAppUserFirstName;
        result.AssignedToAppUserLastName = src.AssignedToAppUserLastName;
        result.VettingBatchStatusID = src.VettingBatchStatusID;
        result.VettingBatchStatus = src.VettingBatchStatus;
        result.IsCorrectionRequired = src.IsCorrectionRequired;
        result.CourtesyVettingOverrideFlag = src.CourtesyVettingOverrideFlag;
        result.CourtesyVettingOverrideReason = src.CourtesyVettingOverrideReason;
        result.GTTSTrackingNumber = src.GTTSTrackingNumber;
        result.LeahyTrackingNumber = src.LeahyTrackingNumber;
        result.INKTrackingNumber = src.INKTrackingNumber;
        result.DateVettingResultsNeededBy = src.DateVettingResultsNeededBy;
        result.DateSubmitted = src.DateSubmitted;
        result.DateAccepted = src.DateAccepted;
        result.DateSentToCourtesy = src.DateSentToCourtesy;
        result.DateCourtesyCompleted = src.DateCourtesyCompleted;
        result.DateSentToLeahy = src.DateSentToLeahy;
        result.DateLeahyResultsReceived = src.DateLeahyResultsReceived;
        result.DateVettingResultsNotified = src.DateVettingResultsNotified;
        result.EventStartDate = src.EventStartDate;
        result.VettingFundingSourceID = src.VettingFundingSourceID;
        result.VettingFundingSource = src.VettingFundingSource;
        result.AuthorizingLawID = src.AuthorizingLawID;
        result.AuthorizingLaw = src.AuthorizingLaw;
        result.VettingBatchNotes = src.VettingBatchNotes;
        result.ModifiedByAppUserID = src.ModifiedByAppUserID;
        result.ModifiedDate = src.ModifiedDate;

        src.Participants.forEach(p => {
            result.PersonVettings.push(VettingBatchParticipant.ToIPersonVetting_Item(p));
        });

        return result;
    }






}


