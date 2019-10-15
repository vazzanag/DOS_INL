

import { IMatchingPerson_Item } from './imatching-person_item';

export class MatchingPerson_Item implements IMatchingPerson_Item {
  
	public PersonID?: number;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public NationalID: string = "";
	public Gender: string = "";
	public IsUSCitizen: string = "";
	public DOB: Date = new Date(0);
	public POBCityID?: number;
	public POBCityName: string = "";
	public POBStateName: string = "";
	public POBCountryName: string = "";
	public LastVettingTypeCode: string = "";
	public LastVettingStatusDate?: Date;
	public LastVettingStatusCode: string = "";
	public JobTitle: string = "";
	public RankName: string = "";
  
}






