


import { ITrainingEventRoster_Item } from './itraining-event-roster_item';

export interface ISaveTrainingEventStudentRoster_Result {
  
	TrainingEventID: number;
	TrainingEventGroupID?: number;
	Students?: ITrainingEventRoster_Item[];

}

