

import { IVettingBatch_Item } from './ivetting-batch_item';
import { ISaveVettingBatches_Param } from './isave-vetting-batches_param';

export class SaveVettingBatches_Param implements ISaveVettingBatches_Param {
  
	public Batches?: IVettingBatch_Item[];
  
	public ErrorMessages: string[] = null;
}


