

import { IVettingBatch_Item } from './ivetting-batch_item';
import { IRejectVettingBatch_Result } from './ireject-vetting-batch_result';

export class RejectVettingBatch_Result implements IRejectVettingBatch_Result {
  
	public Batch?: IVettingBatch_Item;
  
	public ErrorMessages: string[] = null;
}


