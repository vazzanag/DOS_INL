

import { IVettingBatch_Item } from './ivetting-batch_item';
import { IGetVettingBatch_Result } from './iget-vetting-batch_result';

export class GetVettingBatch_Result implements IGetVettingBatch_Result {
  
	public Batch?: IVettingBatch_Item;
  
	public ErrorMessages: string[] = null;
}


