

import { InvestVettingBatch_Item } from './invest-vetting-batch_item';
import { IGetInvestVettingBatch_Result } from './iget-invest-vetting-batch_result';

export class GetInvestVettingBatch_Result implements IGetInvestVettingBatch_Result {
  
	public InvestVettingBatchItems?: InvestVettingBatch_Item[];
	public FileVersion: number = 0;
	public FileName: string = "";
	public FileSize: number = 0;
	public FileHash: number[] = null;
	public FileContent: number[] = null;
  
	public ErrorMessages: string[] = null;
}


