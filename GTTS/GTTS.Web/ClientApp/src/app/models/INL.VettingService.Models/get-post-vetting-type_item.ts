

import { IGetPostVettingType_Item } from './iget-post-vetting-type_item';

export class GetPostVettingType_Item implements IGetPostVettingType_Item {
  
	public PostID: number = 0;
	public VettingTypeID: number = 0;
	public Code: string = "";
	public Description: string = "";
	public IsActive: boolean = false;
  
}


