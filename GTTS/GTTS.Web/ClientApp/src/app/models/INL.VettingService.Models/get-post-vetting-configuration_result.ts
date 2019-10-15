

import { IGetPostVettingConfiguration_Result } from './iget-post-vetting-configuration_result';

export class GetPostVettingConfiguration_Result implements IGetPostVettingConfiguration_Result {
  
	public PostID: number = 0;
	public MaxBatchSize: number = 0;
	public LeahyBatchLeadTime: number = 0;
	public CourtesyBatchLeadTime: number = 0;
	public LeahyBatchExpirationIntervalMonths: number = 0;
	public CourtesyBatchExpirationIntervalMonths: number = 0;
  
}


