

import { IGetPersonsTraining_Item } from './iget-persons-training_item';

export class GetPersonsTraining_Item implements IGetPersonsTraining_Item {
  
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


