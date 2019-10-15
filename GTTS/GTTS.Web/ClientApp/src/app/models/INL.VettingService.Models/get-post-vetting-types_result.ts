

import { GetPostVettingType_Item } from './get-post-vetting-type_item';
import { IGetPostVettingTypes_Result } from './iget-post-vetting-types_result';

export class GetPostVettingTypes_Result implements IGetPostVettingTypes_Result {
  
	public items?: GetPostVettingType_Item[];
  
	public ErrorMessages: string[] = null;
}


