

import { IGetUnitsPaged_Param } from './iget-units-paged_param';

export class GetUnitsPaged_Param implements IGetUnitsPaged_Param {
  
	public PageSize?: number;
	public PageNumber?: number;
	public SortDirection: string = "";
	public SortColumn: string = "";
	public CountryID?: number;
	public IsMainAgency?: boolean;
	public UnitMainAgencyID?: number;
	public IsActive?: boolean;
  
}


