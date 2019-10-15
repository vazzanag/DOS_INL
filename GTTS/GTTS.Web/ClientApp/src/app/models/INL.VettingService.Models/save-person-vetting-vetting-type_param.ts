

import { ISavePersonVettingVettingType_Param } from './isave-person-vetting-vetting-type_param';

export class SavePersonVettingVettingType_Param implements ISavePersonVettingVettingType_Param {
  
	public PersonVettingID?: number;
	public VettingTypeID?: number;
	public CourtesySkippedFlag?: boolean;
	public CourtesySkippedComments: string = "";
	public ModifiedAppUserID?: number;
  
}


