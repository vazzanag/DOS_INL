

import { ITrainingEventRoster_Item } from './itraining-event-roster_item';
import { ISaveTrainingEventRoster_Param } from './isave-training-event-roster_param';

export class SaveTrainingEventRoster_Param implements ISaveTrainingEventRoster_Param {
  
	public TrainingEventID: number = 0;
	public TrainingEventGroupID?: number;
	public ParticipantType: string = "";
	public Participants?: ITrainingEventRoster_Item[];
	public StudentExcelStream?: any;
  
	public ErrorMessages: string[] = null;
}






