

import { TrainingEventInstructor_Item } from './training-event-instructor_item';
import { ISaveTrainingEventInstructors_Param } from './isave-training-event-instructors_param';

export class SaveTrainingEventInstructors_Param implements ISaveTrainingEventInstructors_Param {
  
	public TrainingEventID: number = 0;
	public Collection?: TrainingEventInstructor_Item[];
  
}






