


import { AttachDocumentToVettingHit_Result } from './attach-document-to-vetting-hit_result';

export interface IGetPersonsVettingHit_Item {
  
	VettingHitID: number;
	PersonsVettingID: number;
	VettingTypeID: number;
	FirstMiddleNames: string;
	LastNames: string;
	DOBYear?: number;
	DOBMonth?: number;
	DOBDay?: number;
	PlaceOfBirth: string;
	ReferenceSiteID?: number;
	HitMonth?: number;
	HitDay?: number;
	HitYear?: number;
	UnitID?: number;
	HitUnit: string;
	HitLocation: string;
	ViolationTypeID?: number;
	CredibilityLevelID?: number;
	HitDetails: string;
	Notes: string;
	HitResultID?: number;
	TrackingID: string;
	HitResultDetails: string;
	VettingHitDate?: Date;
	First: string;
	Middle: string;
	Last: string;
	IsRemoved: boolean;
	isHistorical: boolean;
	VettingHitFileAttachmentJSON?: AttachDocumentToVettingHit_Result[];

}

