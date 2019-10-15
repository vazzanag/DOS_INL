

import { IUpdateTypeTrainingEventParticipants_Param } from './iupdate-type-training-event-participants_param';

export class UpdateTypeTrainingEventParticipants_Param implements IUpdateTypeTrainingEventParticipants_Param {
  
	public TrainingEventID: number = 0;
	public PersonIDs: number[] = null;
	public TrainingEventParticipantTypeID: number = 0;
	public RemovalReasonID?: number;
	public RemovalCauseID?: number;
	public DateCanceled?: Date;
  
}






