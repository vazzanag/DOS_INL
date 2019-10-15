

import { ITrainingEventRoster_Item } from './itraining-event-roster_item';

export class SaveTrainingEventStudentRoster_Result {
  
	public TrainingEventID: number = 0;
	public TrainingEventGroupID?: number;
	public Students?: ITrainingEventRoster_Item[];
  
  
  public errorMessages: string[];
}


