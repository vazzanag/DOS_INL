

import { ICancelVettingBatch_Result } from './icancel-vetting-batch_result';

export class CancelVettingBatch_Result implements ICancelVettingBatch_Result {
  
	public VettingBatchID: number[] = null;
  
	public ErrorMessages: string[] = null;
}


