

import { ITrainingEventRoster_Item } from './itraining-event-roster_item';

export class SaveTrainingEventStudentRoster_Param {
  
	public TrainingEventID: number = 0;
	public TrainingEventGroupID?: number;
	public ParticipantType: string = "";
	public Participants?: ITrainingEventRoster_Item[];
	public StudentExcelStream?: any;
	public ModifiedByAppUserID?: number;
  
}


