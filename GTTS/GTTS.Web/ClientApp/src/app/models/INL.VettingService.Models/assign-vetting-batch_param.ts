

import { IAssignVettingBatch_Param } from './iassign-vetting-batch_param';

export class AssignVettingBatch_Param implements IAssignVettingBatch_Param {
  
	public VettingBatchID: number = 0;
	public AssignedToAppUserID: number = 0;
  
	public ErrorMessages: string[] = null;
}


