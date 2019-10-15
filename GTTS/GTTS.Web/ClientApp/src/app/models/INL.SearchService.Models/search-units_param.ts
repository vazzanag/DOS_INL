

import { ISearchUnits_Param } from './isearch-units_param';

export class SearchUnits_Param implements ISearchUnits_Param {
  
	public SearchString: string = "";
	public AgenciesOrUnits?: number;
	public CountryID?: number;
	public UnitMainAgencyID?: number;
	public PageSize?: number;
	public PageNumber?: number;
	public SortOrder: string = "";
	public SortDirection: string = "";
  
}


