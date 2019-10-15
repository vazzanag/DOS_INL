

import { IRejectVettingBatch_Param } from './ireject-vetting-batch_param';

export class RejectVettingBatch_Param implements IRejectVettingBatch_Param {
  
	public VettingBatchID?: number;
	public BatchRejectionReason: string = "";
  
	public ErrorMessages: string[] = null;
}


