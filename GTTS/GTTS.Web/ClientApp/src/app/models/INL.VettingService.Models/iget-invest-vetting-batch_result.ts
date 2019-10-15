


import { InvestVettingBatch_Item } from './invest-vetting-batch_item';

export interface IGetInvestVettingBatch_Result {
  
	InvestVettingBatchItems?: InvestVettingBatch_Item[];
	FileVersion: number;
	FileName: string;
	FileSize: number;
	FileHash: number[];
	FileContent: number[];

}

