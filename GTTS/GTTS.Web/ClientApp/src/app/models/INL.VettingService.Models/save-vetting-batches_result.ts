

import { IVettingBatch_Item } from './ivetting-batch_item';
import { ISaveVettingBatches_Result } from './isave-vetting-batches_result';

export class SaveVettingBatches_Result implements ISaveVettingBatches_Result {
  
	public Batches?: IVettingBatch_Item[];
  
	public ErrorMessages: string[] = null;
}


