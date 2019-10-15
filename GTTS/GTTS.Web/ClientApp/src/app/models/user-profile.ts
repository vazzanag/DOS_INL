import { AppRole } from "@models/app-role";
import { BusinessUnit } from "@models/business-unit";
import { AppPermission } from '@models/app-permission';


export class UserProfile {
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
    public CountryID?: number = null;
    public CountryName: string = "";
    public PostID?: number = null;
    public PostName: string = "";
    
    public AppRoles?: AppRole[];
    public AppPermissions?: AppPermission[];
    public BusinessUnits?: BusinessUnit[];
    public DefaultBusinessUnit?: BusinessUnit;
    public DefaultAppRole?: AppRole;


}


