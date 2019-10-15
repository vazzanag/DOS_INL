

import { GetTrainingEventRoster_Item } from './get-training-event-roster_item';
import { IGetTrainingEventRosterGroups_Item } from './iget-training-event-roster-groups_item';

export class GetTrainingEventRosterGroups_Item implements IGetTrainingEventRosterGroups_Item {
  
	public GroupName: string = "";
	public TrainingEventGroupID: number = 0;
	public Rosters?: GetTrainingEventRoster_Item[];
  
}






