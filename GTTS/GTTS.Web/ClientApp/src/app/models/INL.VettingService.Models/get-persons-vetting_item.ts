

import { IGetPersonsVetting_Item } from './iget-persons-vetting_item';

export class GetPersonsVetting_Item implements IGetPersonsVetting_Item {
  
	public PersonsVettingID: number = 0;
	public PersonID: number = 0;
	public VettingPersonStatusID: number = 0;
	public VettingStatus: string = "";
	public BatchID: string = "";
	public TrackingNumber: string = "";
	public VettingValidStartDate?: Date;
	public VettingValidEndDate?: Date;
	public RemovedFromVetting?: boolean;
  
}


