



export interface IGetPersonsVetting_Item {
  
	PersonsVettingID: number;
	PersonID: number;
	VettingPersonStatusID: number;
	VettingStatus: string;
	BatchID: string;
	TrackingNumber: string;
	VettingValidStartDate?: Date;
	VettingValidEndDate?: Date;
	RemovedFromVetting?: boolean;

}

