

import { SearchTrainingEvents_Item } from './search-training-events_item';
import { ISearchTrainingEvents_Result } from './isearch-training-events_result';

export class SearchTrainingEvents_Result implements ISearchTrainingEvents_Result {
  
	public Collection?: SearchTrainingEvents_Item[];
  
	public ErrorMessages: string[] = null;
}


