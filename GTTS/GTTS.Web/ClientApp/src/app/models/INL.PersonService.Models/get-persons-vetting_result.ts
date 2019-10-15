

import { GetPersonsVetting_Item } from './get-persons-vetting_item';
import { IGetPersonsVetting_Result } from './iget-persons-vetting_result';

export class GetPersonsVetting_Result implements IGetPersonsVetting_Result {
  
	public VettingCollection?: GetPersonsVetting_Item[];
  
}


