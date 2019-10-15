


import { IBaseFileAttachment_Item } from './ibase-file-attachment_item';

export interface IVettingHit_Item {
  
	VettingHitID: number;
	PersonsVettingID: number;
	VettingTypeID: number;
	FirstMiddleNames: string;
	LastNames: string;
	DOB?: Date;
	PlaceOfBirth: string;
	ReferenceSiteID?: number;
	HitMonth?: number;
	HitDay?: number;
	HitYear?: number;
	UnitID?: number;
	HitLocation: string;
	ViolationTypeID?: number;
	CredibilityLevelID?: number;
	HitDetails: string;
	Notes: string;
	HitResultID?: number;
	HitResultDetails: string;
	VettingHitDate?: Date;
	VettingHitFileAttachments?: IBaseFileAttachment_Item[];

}

