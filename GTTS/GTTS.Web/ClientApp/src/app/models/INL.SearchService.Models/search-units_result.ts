

import { SearchUnits_Item } from './search-units_item';
import { ISearchUnits_Result } from './isearch-units_result';

export class SearchUnits_Result implements ISearchUnits_Result {
  
	public RecordCount: number = 0;
	public Collection?: SearchUnits_Item[];
  
}


