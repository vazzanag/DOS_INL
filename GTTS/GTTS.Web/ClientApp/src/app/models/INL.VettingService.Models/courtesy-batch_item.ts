

import { ICourtesyBatch_Item } from './icourtesy-batch_item';

export class CourtesyBatch_Item implements ICourtesyBatch_Item {
  
	public CourtesyBatchID: number = 0;
	public VettingBatchID: number = 0;
	public VettingTypeID: number = 0;
	public VettingType: string = "";
	public VettingBatchNotes: string = "";
	public AssignedToAppUserID?: number;
	public AssignedToAppUserName: string = "";
	public ResultsSubmittedDate?: Date;
	public ResultsSubmittedByAppUserID?: number;
	public ResultsSubmittedByAppUserName: string = "";
  
}


