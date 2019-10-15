

import { GetTrainingEventInstructor_Item } from './get-training-event-instructor_item';
import { ISaveTrainingEventInstructors_Result } from './isave-training-event-instructors_result';

export class SaveTrainingEventInstructors_Result implements ISaveTrainingEventInstructors_Result {
  
	public Collection?: GetTrainingEventInstructor_Item[];
  
	public ErrorMessages: string[] = null;
}






