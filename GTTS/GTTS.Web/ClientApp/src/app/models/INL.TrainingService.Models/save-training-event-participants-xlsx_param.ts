

import { TrainingEventParticipantXLSX_Item } from './training-event-participant-xlsx_item';
import { ISaveTrainingEventParticipantsXLSX_Param } from './isave-training-event-participants-xlsx_param';

export class SaveTrainingEventParticipantsXLSX_Param implements ISaveTrainingEventParticipantsXLSX_Param {
  
	public TrainingEventID?: number;
	public ParticipantsExcelStream?: any;
	public Participants?: TrainingEventParticipantXLSX_Item[];
  
}






