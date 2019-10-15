

import { IBaseFileAttachment_Item } from './ibase-file-attachment_item';

export class VettingHit_Item {
  
	public VettingHitID: number = 0;
	public PersonsVettingID: number = 0;
	public VettingTypeID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOB?: Date;
	public PlaceOfBirth: string = "";
	public ReferenceSiteID?: number;
	public HitMonth?: number;
	public HitDay?: number;
	public HitYear?: number;
	public UnitID?: number;
	public HitLocation: string = "";
	public ViolationTypeID?: number;
	public CredibilityLevelID?: number;
	public HitDetails: string = "";
	public Notes: string = "";
	public HitResultID?: number;
	public HitResultDetails: string = "";
	public VettingHitDate?: Date;
    public VettingHitFileAttachments?: IBaseFileAttachment_Item[];
  
}


