

import { IVettingBatch_Item } from './ivetting-batch_item';
import { IGetVettingBatches_Result } from './iget-vetting-batches_result';

export class GetVettingBatches_Result implements IGetVettingBatches_Result {
  
	public Batches?: IVettingBatch_Item[];
  
	public ErrorMessages: string[] = null;
}


