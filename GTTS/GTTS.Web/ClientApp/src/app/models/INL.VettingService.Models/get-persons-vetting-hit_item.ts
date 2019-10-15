

import { AttachDocumentToVettingHit_Result } from './attach-document-to-vetting-hit_result';
import { IGetPersonsVettingHit_Item } from './iget-persons-vetting-hit_item';

export class GetPersonsVettingHit_Item implements IGetPersonsVettingHit_Item {
  
	public VettingHitID: number = 0;
	public PersonsVettingID: number = 0;
	public VettingTypeID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOBYear?: number;
	public DOBMonth?: number;
	public DOBDay?: number;
	public PlaceOfBirth: string = "";
	public ReferenceSiteID?: number;
	public HitMonth?: number;
	public HitDay?: number;
	public HitYear?: number;
	public UnitID?: number;
	public HitUnit: string = "";
	public HitLocation: string = "";
	public ViolationTypeID?: number;
	public CredibilityLevelID?: number;
	public HitDetails: string = "";
	public Notes: string = "";
	public TrackingID: string = "";
	public HitResultID?: number;
	public HitResultDetails: string = "";
	public VettingHitDate?: Date;
	public First: string = "";
	public Middle: string = "";
	public Last: string = "";
	public IsRemoved: boolean = false;
	public isHistorical: boolean = false;
	public VettingHitFileAttachmentJSON?: AttachDocumentToVettingHit_Result[];
  
}


