


import { ISearchPersons_Item } from './isearch-persons_item';

export interface ISearchPersons_Result {
  
	Collection?: ISearchPersons_Item[];
	Draw: number;
	RecordsFiltered: number;
	RecordsTotal: number;

}

