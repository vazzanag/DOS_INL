

import { ITrainingEventTypesAtBusinessUnit_Item } from './itraining-event-types-at-business-unit_item';

export class TrainingEventTypesAtBusinessUnit_Item implements ITrainingEventTypesAtBusinessUnit_Item {
  
	public TrainingEventTypeID: number = 0;
	public TrainingEventTypeName: string = "";
	public BusinessUnitID: number = 0;
	public Acronym: string = "";
	public BusinessUnitName: string = "";
	public BusinessUnitActive: boolean = false;
	public TrainingEventTypeBusinessUnitActive: boolean = false;
  
}






