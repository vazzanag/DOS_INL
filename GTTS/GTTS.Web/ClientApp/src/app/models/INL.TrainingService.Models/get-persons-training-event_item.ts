

import { IGetPersonsTrainingEvent_Item } from './iget-persons-training-event_item';

export class GetPersonsTrainingEvent_Item implements IGetPersonsTrainingEvent_Item {
  
	public TrainingEventID: number = 0;
	public Name: string = "";
	public PersonID: number = 0;
	public ParticipantType: string = "";
	public EventStartDate?: Date;
	public EventEndDate?: Date;
	public BusinessUnitAcronym: string = "";
	public TrainingEventRosterDistinction: string = "";
	public Certificate?: boolean;
	public TrainingEventStatus: string = "";
  
}






