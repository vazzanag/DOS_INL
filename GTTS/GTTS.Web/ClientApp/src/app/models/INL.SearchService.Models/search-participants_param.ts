

import { ISearchParticipants_Param } from './isearch-participants_param';

export class SearchParticipants_Param implements ISearchParticipants_Param {
  
	public SearchString: string = "";
	public Context: string = "";
	public CountryID?: number;
	public TrainingEventID?: number;
	public IncludeVettingOnly?: boolean;
  
}


