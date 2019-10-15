

import { ISaveLeahyVettingHit_Param } from './isave-leahy-vetting-hit_param';

export class SaveLeahyVettingHit_Param implements ISaveLeahyVettingHit_Param {
  
	public LeahyVettingHitID?: number;
	public PersonsVettingID?: number;
	public CaseID: string = "";
	public LeahyHitResultID?: number;
	public LeahyHitAppliesToID?: number;
	public ViolationTypeID?: number;
	public CertDate?: Date;
	public ExpiresDate?: Date;
	public Summary: string = "";
  
}


