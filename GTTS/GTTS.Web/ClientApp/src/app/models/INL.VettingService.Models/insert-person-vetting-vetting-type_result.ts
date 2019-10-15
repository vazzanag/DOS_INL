

import { InsertPersonVettingVettingType_Item } from './insert-person-vetting-vetting-type_item';
import { IInsertPersonVettingVettingType_Result } from './iinsert-person-vetting-vetting-type_result';

export class InsertPersonVettingVettingType_Result implements IInsertPersonVettingVettingType_Result {
  
	public items?: InsertPersonVettingVettingType_Item[];
  
	public ErrorMessages: string[] = null;
}


