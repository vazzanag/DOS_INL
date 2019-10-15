

import { ISaveCourtesyBatch_Param } from './isave-courtesy-batch_param';

export class SaveCourtesyBatch_Param implements ISaveCourtesyBatch_Param {
  
	public CourtesyBatchID?: number;
	public VettingBatchID?: number;
	public VettingTypeID?: number;
	public VettingBatchNotes: string = "";
	public AssignedToAppUserID?: number;
	public ResultsSubmittedDate?: Date;
	public ResultsSubmittedByAppUserID?: number;
	public isSubmit: boolean = false;
  
}


