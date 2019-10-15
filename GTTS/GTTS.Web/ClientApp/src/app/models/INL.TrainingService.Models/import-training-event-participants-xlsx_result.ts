

import { IImportTrainingEventParticipantsXLSX_Result } from './iimport-training-event-participants-xlsx_result';

export class ImportTrainingEventParticipantsXLSX_Result implements IImportTrainingEventParticipantsXLSX_Result {
  
	public TrainingEventID: number = 0;
	public IsSuccessfullyImported: boolean = false;
  
	public ErrorMessages: string[] = null;
}






