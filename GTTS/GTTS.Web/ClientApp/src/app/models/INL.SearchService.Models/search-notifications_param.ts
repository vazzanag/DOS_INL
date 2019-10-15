

import { ISearchNotifications_Param } from './isearch-notifications_param';

export class SearchNotifications_Param implements ISearchNotifications_Param {
  
	public SearchString: string = "";
	public AppUserID?: number;
	public ContextID?: number;
	public ContextTypeID?: number;
	public PageSize?: number;
	public PageNumber?: number;
	public SortOrder: string = "";
	public SortDirection: string = "";
  
}


