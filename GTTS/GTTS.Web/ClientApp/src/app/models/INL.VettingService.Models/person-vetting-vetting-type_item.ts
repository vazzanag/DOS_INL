

import { IPersonVettingVettingType_Item } from './iperson-vetting-vetting-type_item';

export class PersonVettingVettingType_Item implements IPersonVettingVettingType_Item {
  
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOB?: Date;
	public PersonsVettingID: number = 0;
	public VettingTypeID: number = 0;
	public VettingTypeCode: string = "";
	public CourtesyVettingSkipped: boolean = false;
	public CourtesyVettingSkippedComments: string = "";
	public HitResultID?: number;
	public HitResultDetails: string = "";
	public HitResultCode: string = "";
  
}


