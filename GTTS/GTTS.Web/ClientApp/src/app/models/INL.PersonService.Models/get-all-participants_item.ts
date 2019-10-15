

import { IGetAllParticipants_Item } from './iget-all-participants_item';

export class GetAllParticipants_Item implements IGetAllParticipants_Item {
  
	public PersonID: number = 0;
	public CountryID?: number;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender: string = "";
	public AgencyName: string = "";
	public RankName: string = "";
	public JobTitle: string = "";
	public LastVettingTypeCode: string = "";
	public LastVettingStatusCode: string = "";
	public LastVettingStatusDate?: Date;
	public ParticipantType: string = "";
	public Distinction: string = "";
	public UnitName: string = "";
	public VettingValidEndDate?: Date;
	public TrainingDate?: Date;
	public DOB?: Date;
	public UnitNameEnglish: string = "";
	public UnitAcronym: string = "";
	public AgencyNameEnglish: string = "";
	public NationalID: string = "";
  
}


