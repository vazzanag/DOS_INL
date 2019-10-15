

import { IPersonVettingVettingType_Item } from './iperson-vetting-vetting-type_item';
import { IGetPersonVettingVettingType_Result } from './iget-person-vetting-vetting-type_result';

export class GetPersonVettingVettingType_Result implements IGetPersonVettingVettingType_Result {
  
	public item?: IPersonVettingVettingType_Item;
  
	public ErrorMessages: string[] = null;
}


