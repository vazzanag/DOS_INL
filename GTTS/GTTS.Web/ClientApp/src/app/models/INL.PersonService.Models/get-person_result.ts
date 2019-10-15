

import { GetPerson_Item } from './get-person_item';
import { IGetPerson_Result } from './iget-person_result';

export class GetPerson_Result implements IGetPerson_Result {
  
	public Item?: GetPerson_Item;
  
	public ErrorMessages: string[] = null;
}


