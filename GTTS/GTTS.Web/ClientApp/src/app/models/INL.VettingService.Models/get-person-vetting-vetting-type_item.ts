

import { IGetPersonVettingVettingType_Item } from './iget-person-vetting-vetting-type_item';

export class GetPersonVettingVettingType_Item implements IGetPersonVettingVettingType_Item {
  
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public PersonsVettingID: number = 0;
	public VettingTypeID?: number;
	public VettingTypeCode: string = "";
	public CourtesyVettingSkipped?: boolean;
	public CourtestVettingSkippedComments: string = "";
  
}


