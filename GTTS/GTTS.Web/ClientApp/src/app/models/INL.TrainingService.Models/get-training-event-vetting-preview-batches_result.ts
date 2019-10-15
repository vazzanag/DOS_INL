

import { GetTrainingEventBatch_Item } from './get-training-event-batch_item';
import { IGetTrainingEventVettingPreviewBatches_Result } from './iget-training-event-vetting-preview-batches_result';

export class GetTrainingEventVettingPreviewBatches_Result implements IGetTrainingEventVettingPreviewBatches_Result {
  
	public MaxBatchSize: number = 0;
	public LeahyBatchLeadTime: number = 0;
	public CourtesyBatchLeadTime: number = 0;
	public LeahyBatches?: GetTrainingEventBatch_Item[];
	public CourtesyBatches?: GetTrainingEventBatch_Item[];
	public LeahyReVettingBatches?: GetTrainingEventBatch_Item[];
	public CourtesyReVettingBatches?: GetTrainingEventBatch_Item[];
  
}






