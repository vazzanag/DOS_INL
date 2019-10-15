

import { IGetStudents_Item } from './iget-students_item';

export class GetStudents_Item implements IGetStudents_Item {
  
	public PersonID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOB?: Date;
	public Gender: string = "";
	public JobTitle: string = "";
	public JobRank?: number;
	public CountryID: number = 0;
	public CountryName: string = "";
	public CountryFullName: string = "";
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public UnitMainAgencyID?: number;
	public VettingStatus: string = "";
	public VettingStatusDate?: Date;
	public VettingType: string = "";
	public Distinction: string = "";
  
}


