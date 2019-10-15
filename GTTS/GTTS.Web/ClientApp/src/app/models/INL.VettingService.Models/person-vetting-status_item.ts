

import { IPersonVettingStatus_Item } from './iperson-vetting-status_item';

export class PersonVettingStatus_Item implements IPersonVettingStatus_Item {
  
	public PersonID: number = 0;
	public TrainingEventID?: number;
	public VettingBatchStatusID: number = 0;
	public BatchStatus: string = "";
	public VettingPersonStatusID: number = 0;
	public PersonsVettingStatus: string = "";
	public DateLeahyFileGenerated?: Date;
	public VettingBatchStatusDate?: Date;
	public ExpirationDate?: Date;
	public RemovedFromVetting: boolean = false;
	public VettingStatusDate?: Date;
	public VettingBatchTypeID: number = 0;
  
}


