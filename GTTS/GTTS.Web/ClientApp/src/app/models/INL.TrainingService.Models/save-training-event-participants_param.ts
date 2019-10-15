

import { TrainingEventStudent_Item } from './training-event-student_item';
import { ISaveTrainingEventParticipants_Param } from './isave-training-event-participants_param';

export class SaveTrainingEventParticipants_Param implements ISaveTrainingEventParticipants_Param {
  
	public TrainingEventID: number = 0;
	public Collection?: TrainingEventStudent_Item[];
  
}






