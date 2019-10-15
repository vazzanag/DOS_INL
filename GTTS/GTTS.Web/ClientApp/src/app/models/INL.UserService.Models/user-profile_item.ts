

import { IBusinessUnit_Item } from './ibusiness-unit_item';
import { IAppRole_Item } from './iapp-role_item';
import { IAppPermission_Item } from './iapp-permission_item';
import { IUserProfile_Item } from './iuser-profile_item';

export class UserProfile_Item implements IUserProfile_Item {
  
	public AppUserID: number = 0;
	public ADOID: string = "";
	public First: string = "";
	public Middle: string = "";
	public Last: string = "";
	public FullName: string = "";
	public PositionTitle: string = "";
	public EmailAddress: string = "";
	public PhoneNumber: string = "";
	public PicturePath: string = "";
	public CountryID?: number;
	public CountryName: string = "";
	public PostID?: number;
	public PostName: string = "";
	public DefaultBusinessUnit?: IBusinessUnit_Item;
	public DefaultAppRole?: IAppRole_Item;
	public ModifiedByAppUserID: number = 0;
	public AppRoles?: IAppRole_Item[];
	public AppPermissions?: IAppPermission_Item[];
	public BusinessUnits?: IBusinessUnit_Item[];
  
}


