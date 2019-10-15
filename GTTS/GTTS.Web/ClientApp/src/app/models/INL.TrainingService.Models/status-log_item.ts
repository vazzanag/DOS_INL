

import { IStatusLog_Item } from './istatus-log_item';

export class StatusLog_Item implements IStatusLog_Item {
  
	public TrainingEventStatusLogID: number = 0;
	public TrainingEventID: number = 0;
	public TrainingEventStatusID: number = 0;
	public TrainingEventStatus: string = "";
	public ReasonStatusChanged: string = "";
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}






