

import { GetTrainingEventRoster_Item } from './get-training-event-roster_item';
import { IGetTrainingEventRoster_Result } from './iget-training-event-roster_result';

export class GetTrainingEventRoster_Result implements IGetTrainingEventRoster_Result {
  
	public TrainingEventID: number = 0;
	public Rosters?: GetTrainingEventRoster_Item[];
  
}






