

import { IVettingBatch_Item } from './ivetting-batch_item';
import { IUpdateVettingBatch_Result } from './iupdate-vetting-batch_result';

export class UpdateVettingBatch_Result implements IUpdateVettingBatch_Result {
  
	public Batch?: IVettingBatch_Item;
  
	public ErrorMessages: string[] = null;
}


