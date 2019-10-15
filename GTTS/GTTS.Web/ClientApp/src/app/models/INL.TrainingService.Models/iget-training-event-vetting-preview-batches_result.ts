


import { GetTrainingEventBatch_Item } from './get-training-event-batch_item';

export interface IGetTrainingEventVettingPreviewBatches_Result {
  
	MaxBatchSize: number;
	LeahyBatchLeadTime: number;
	CourtesyBatchLeadTime: number;
	LeahyBatches?: GetTrainingEventBatch_Item[];
	CourtesyBatches?: GetTrainingEventBatch_Item[];
	LeahyReVettingBatches?: GetTrainingEventBatch_Item[];
	CourtesyReVettingBatches?: GetTrainingEventBatch_Item[];
}





