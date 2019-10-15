

import { IPersonVettingVettingType_Item } from './iperson-vetting-vetting-type_item';
import { ISavePersonVettingVettingType_Result } from './isave-person-vetting-vetting-type_result';

export class SavePersonVettingVettingType_Result implements ISavePersonVettingVettingType_Result {
  
	public item?: IPersonVettingVettingType_Item;
  
	public ErrorMessages: string[] = null;
}


