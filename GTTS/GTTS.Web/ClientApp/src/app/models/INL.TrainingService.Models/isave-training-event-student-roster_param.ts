﻿


import { ITrainingEventRoster_Item } from './itraining-event-roster_item';

export interface ISaveTrainingEventStudentRoster_Param {
  
	TrainingEventID: number;
	TrainingEventGroupID?: number;
	ParticipantType: string;
	Participants?: ITrainingEventRoster_Item[];
	StudentExcelStream?: any;
	ModifiedByAppUserID?: number;

}

