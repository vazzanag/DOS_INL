

import { GetMatchingPersons_Item } from './get-matching-persons_item';
import { IGetMatchingPersons_Result } from './iget-matching-persons_result';

export class GetMatchingPersons_Result implements IGetMatchingPersons_Result {
  
	public MatchingPersons?: GetMatchingPersons_Item[];
  
}


