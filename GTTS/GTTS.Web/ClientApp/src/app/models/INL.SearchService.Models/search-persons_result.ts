

import { ISearchPersons_Item } from './isearch-persons_item';
import { ISearchPersons_Result } from './isearch-persons_result';

export class SearchPersons_Result implements ISearchPersons_Result {
  
	public Collection?: ISearchPersons_Item[];
	public Draw: number = 0;
	public RecordsFiltered: number = 0;
	public RecordsTotal: number = 0;
  
}


