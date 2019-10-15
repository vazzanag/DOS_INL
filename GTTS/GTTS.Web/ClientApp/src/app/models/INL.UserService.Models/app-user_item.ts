

import { IAppUser_Item } from './iapp-user_item';

export class AppUser_Item implements IAppUser_Item {
  
	public AppUserID: number = 0;
	public First: string = "";
	public Last: string = "";
	public Middle: string = "";
	public FullName: string = "";
	public PositionTitle: string = "";
	public EmailAddress: string = "";
	public PhoneNumber: string = "";
	public PicturePath: string = "";
	public CountryID?: number;
	public CountryName: string = "";
	public PostID?: number;
	public PostName: string = "";
  
}


