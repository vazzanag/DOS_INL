


import { IBusinessUnit_Item } from './ibusiness-unit_item';
import { IAppRole_Item } from './iapp-role_item';
import { IAppPermission_Item } from './iapp-permission_item';

export interface IUserProfile_Item {
  
	AppUserID: number;
	ADOID: string;
	First: string;
	Middle: string;
	Last: string;
	FullName: string;
	PositionTitle: string;
	EmailAddress: string;
	PhoneNumber: string;
	PicturePath: string;
	CountryID?: number;
	CountryName: string;
	PostID?: number;
	PostName: string;
	DefaultBusinessUnit?: IBusinessUnit_Item;
	DefaultAppRole?: IAppRole_Item;
	ModifiedByAppUserID: number;
	AppRoles?: IAppRole_Item[];
	AppPermissions?: IAppPermission_Item[];
	BusinessUnits?: IBusinessUnit_Item[];

}

