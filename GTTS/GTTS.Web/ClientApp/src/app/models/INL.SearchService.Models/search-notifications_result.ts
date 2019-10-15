

import { SearchNotifications_Item } from './search-notifications_item';
import { ISearchNotifications_Result } from './isearch-notifications_result';

export class SearchNotifications_Result implements ISearchNotifications_Result {
  
	public RecordCount: number = 0;
	public Collection?: SearchNotifications_Item[];
  
}


