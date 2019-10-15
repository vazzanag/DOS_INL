


import { GetTrainingEventRoster_Item } from './get-training-event-roster_item';

export interface ITrainingEventRosterGroup {
  
	GroupName: string;
	TrainingEventGroupID: number;
	Rosters?: GetTrainingEventRoster_Item[];

}

