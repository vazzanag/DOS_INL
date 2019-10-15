



export interface IGetPersonsTraining_Item {
  
	TrainingEventID: number;
	Name: string;
	PersonID: number;
	ParticipantType: string;
	EventStartDate?: Date;
	EventEndDate?: Date;
	BusinessUnitAcronym: string;
	TrainingEventRosterDistinction: string;
	Certificate?: boolean;
	TrainingEventStatus: string;

}

