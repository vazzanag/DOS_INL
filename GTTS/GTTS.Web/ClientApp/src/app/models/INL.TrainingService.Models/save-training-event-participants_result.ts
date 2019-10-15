

import { SaveTrainingEventParticipants_Item } from './save-training-event-participants_item';
import { ISaveTrainingEventParticipants_Result } from './isave-training-event-participants_result';

export class SaveTrainingEventParticipants_Result implements ISaveTrainingEventParticipants_Result {
  
	public Collection?: SaveTrainingEventParticipants_Item[];
  
	public ErrorMessages: string[] = null;
}






