

import { ISearchParticipants_Item } from './isearch-participants_item';
import { ISearchParticipants_Result } from './isearch-participants_result';

export class SearchParticipants_Result implements ISearchParticipants_Result {
  
	public Collection?: ISearchParticipants_Item[];
  
	public ErrorMessages: string[] = null;
}


