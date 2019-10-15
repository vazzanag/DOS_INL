



export interface IPersonVettingStatus_Item {
  
	PersonID: number;
	TrainingEventID?: number;
	VettingBatchStatusID: number;
	BatchStatus: string;
	VettingPersonStatusID: number;
	PersonsVettingStatus: string;
	DateLeahyFileGenerated?: Date;
	VettingBatchStatusDate?: Date;
	ExpirationDate?: Date;
	RemovedFromVetting: boolean;
	VettingStatusDate?: Date;
	VettingBatchTypeID: number;

}

