

import { IPersonUnit_Item } from './iperson-unit_item';
import { IGetPersonUnit_Result } from './iget-person-unit_result';

export class GetPersonUnit_Result implements IGetPersonUnit_Result {
  
	public Item?: IPersonUnit_Item;
  
	public ErrorMessages: string[] = null;
}


