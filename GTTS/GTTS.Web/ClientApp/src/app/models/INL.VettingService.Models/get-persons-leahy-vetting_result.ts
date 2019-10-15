

import { GetPersonsLeahyVetting_Item } from './get-persons-leahy-vetting_item';
import { IGetPersonsLeahyVetting_Result } from './iget-persons-leahy-vetting_result';

export class GetPersonsLeahyVetting_Result implements IGetPersonsLeahyVetting_Result {
  
	public item?: GetPersonsLeahyVetting_Item;
  
	public ErrorMessages: string[] = null;
}


