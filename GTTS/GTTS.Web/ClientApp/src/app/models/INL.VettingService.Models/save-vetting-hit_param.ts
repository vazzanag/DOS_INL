

import { ISaveVettingHit_Param } from './isave-vetting-hit_param';

export class SaveVettingHit_Param implements ISaveVettingHit_Param {
  
	public VettingHitID?: number;
	public PersonsVettingID: number = 0;
	public VettingTypeID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOBMonth?: number;
	public DOBDay?: number;
	public DOBYear?: number;
	public PlaceOfBirth: string = "";
	public ReferenceSiteID?: number;
	public HitMonth?: number;
	public HitDay?: number;
	public HitYear?: number;
	public TrackingID: string = "";
	public HitUnit: string = "";
	public HitLocation: string = "";
	public ViolationTypeID?: number;
	public CredibilityLevelID?: number;
	public HitDetails: string = "";
	public Notes: string = "";
	public HitResultID?: number;
	public HitResultDetails: string = "";
	public IsRemoved?: boolean;
  
}


