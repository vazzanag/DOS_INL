

import { IGetTrainingEventStudentRoster_Item } from './iget-training-event-student-roster_item';

export class GetTrainingEventStudentRoster_Item implements IGetTrainingEventStudentRoster_Item {
  
	public TrainingEventID: number = 0;
	public TrainingEventName: string = "";
	public TrainingEventGroupID?: number;
	public TrainingEventGroupName: string = "";
	public FileContent: number[] = null;
  
}






