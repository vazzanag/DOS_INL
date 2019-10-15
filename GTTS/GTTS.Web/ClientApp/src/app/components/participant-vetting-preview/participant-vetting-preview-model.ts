import { GetTrainingEventBatch_Item } from '@models/INL.TrainingService.Models/get-training-event-batch_item';
import { GetTrainingEventBatchParticipants_Item } from '@models/INL.TrainingService.Models/get-training-event-batch-participants_item';

export class ParticipantVettingPreviewModel  {

    public MaxBatchSize: number = 0;
    public LeahyBatchLeadTime: number = 35;
    public CourtesyBatchLeadTime: number = 5;
    public LeahyBatches?: GetTrainingEventBatch_Item[];
    public CourtesyBatches?: GetTrainingEventBatch_Item[];
    public LeahyReVettingBatches?: GetTrainingEventBatch_Item[];
    public CourtesyReVettingBatches?: GetTrainingEventBatch_Item[];
    public RemovedParticipants?: GetTrainingEventBatch_Item[];

    get SubmitEnabled() {
        if ((this.CourtesyBatches === undefined || this.CourtesyBatches === null) && (this.LeahyBatches === undefined || this.LeahyBatches === null))
            return false;
        let noOfParticipants = 0;
        this.LeahyBatches.map(b => {
            noOfParticipants += b.Participants.length;
        });
        this.CourtesyBatches.map(b => {
            noOfParticipants += b.Participants.length;
        });
        this.LeahyReVettingBatches.map(b => {
            noOfParticipants += b.Participants.length;
        });
        this.CourtesyReVettingBatches.map(b => {
            noOfParticipants += b.Participants.length;
        });
        if (noOfParticipants > 0) {
            return true;
        }
        else {
            return false;
        }
    }
}
