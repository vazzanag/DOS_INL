

import { ISavePersonsVettingStatus_Param } from './isave-persons-vetting-status_param';

export class SavePersonsVettingStatus_Param implements ISavePersonsVettingStatus_Param {
  
	public PersonsVettingID?: number;
	public VettingStatus: string = "";
	public IsClear?: boolean;
	public IsDeny?: boolean;
	public ModifiedAppUserID?: number;
  
}


