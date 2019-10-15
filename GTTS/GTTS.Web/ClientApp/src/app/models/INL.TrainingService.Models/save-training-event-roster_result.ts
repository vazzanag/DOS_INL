

import { ITrainingEventRoster_Item } from './itraining-event-roster_item';
import { ISaveTrainingEventRoster_Result } from './isave-training-event-roster_result';

export class SaveTrainingEventRoster_Result implements ISaveTrainingEventRoster_Result {
  
	public TrainingEventID: number = 0;
	public TrainingEventGroupID?: number;
	public Students?: ITrainingEventRoster_Item[];
  
	public ErrorMessages: string[] = null;
}






