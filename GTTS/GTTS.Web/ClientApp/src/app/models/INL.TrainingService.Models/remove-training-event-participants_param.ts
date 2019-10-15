

import { IRemoveTrainingEventParticipants_Param } from './iremove-training-event-participants_param';

export class RemoveTrainingEventParticipants_Param implements IRemoveTrainingEventParticipants_Param {
  
	public TrainingEventID: number = 0;
	public PersonIDs: number[] = null;
	public RemovalReasonID?: number;
	public RemovalCauseID?: number;
	public DateCanceled?: Date;
  
}






