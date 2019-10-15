

import { IDeleteTrainingEventParticipant_Param } from './idelete-training-event-participant_param';

export class DeleteTrainingEventParticipant_Param implements IDeleteTrainingEventParticipant_Param {
  
	public TrainingEventID: number = 0;
	public ParticipantID: number = 0;
	public ParticipantType: string = "";
  
	public ErrorMessages: string[] = null;
}






