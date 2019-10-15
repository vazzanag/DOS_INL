

import { IUpdateVettingBatch_Param } from './iupdate-vetting-batch_param';

export class UpdateVettingBatch_Param implements IUpdateVettingBatch_Param {
  
	public VettingBatchID: number = 0;
	public AssignedToAppUserID?: number;
	public VettingBatchNotes: string = "";
	public VettingBatchStatus: string = "";
	public VettingTypeID?: number;
	public INKTrackingNumber: string = "";
	public LeahyTrackingNumber: string = "";
  
	public ErrorMessages: string[] = null;
}


