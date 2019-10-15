

import { ISearchPersons_Param } from './isearch-persons_param';

export class SearchPersons_Param implements ISearchPersons_Param {
  
	public SearchString: string = "";
	public CountryID?: number;
	public PageSize?: number;
	public PageNumber?: number;
	public OrderColumn: string = "";
	public OrderDirection: string = "";
	public ParticipantType: string = "";
  
}


