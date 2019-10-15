

import { IGetTrainingEventRosterGroups_Item } from './iget-training-event-roster-groups_item';
import { IGetTrainingEventRosterInGroups_Result } from './iget-training-event-roster-in-groups_result';

export class GetTrainingEventRosterInGroups_Result implements IGetTrainingEventRosterInGroups_Result {
  
	public TrainingEventID: number = 0;
	public RosterGroups?: IGetTrainingEventRosterGroups_Item[];
  
}






