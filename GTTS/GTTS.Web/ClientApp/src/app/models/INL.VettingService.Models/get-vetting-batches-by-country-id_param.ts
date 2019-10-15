

import { IGetVettingBatchesByCountryID_Param } from './iget-vetting-batches-by-country-id_param';

export class GetVettingBatchesByCountryID_Param implements IGetVettingBatchesByCountryID_Param {
  
	public CountryID: number = 0;
	public VettingBatchStatus: string = "";
	public IsCorrectionRequired?: boolean;
	public HasHits?: boolean;
	public CourtesyType: string = "";
	public AllHits?: boolean;
	public CourtesyStatus: string = "";
  
}


