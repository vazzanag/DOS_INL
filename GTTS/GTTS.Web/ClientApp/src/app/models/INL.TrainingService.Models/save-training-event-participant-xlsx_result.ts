

import { ISaveTrainingEventParticipantXLSX_Result } from './isave-training-event-participant-xlsx_result';

export class SaveTrainingEventParticipantXLSX_Result implements ISaveTrainingEventParticipantXLSX_Result {
  
	public ParticipantXLSXID: number = 0;
	public ParticipantStatus: string = "";
	public FirstMiddleName: string = "";
	public LastName: string = "";
	public NationalID: string = "";
	public Gender?: string;
	public IsUSCitizen: string = "";
	public DOB?: Date;
	public POBCity: string = "";
	public POBState: string = "";
	public POBCountry: string = "";
	public ModifiedByAppUserID?: number;
  
	public ErrorMessages: string[] = null;
}






