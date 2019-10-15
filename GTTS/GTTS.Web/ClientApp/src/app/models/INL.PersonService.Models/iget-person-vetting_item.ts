



export interface IGetPersonVetting_Item {
  
	PersonsVettingID: number;
	PersonID: number;
	VettingPersonStatusID: number;
	VettingStatus: string;
	BatchID: string;
	TrackingNumber: string;
	VettingValidStartDate?: Date;
	VettingValidEndDate?: Date;

}

