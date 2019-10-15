

import { IGetInstructors_Item } from './iget-instructors_item';

export class GetInstructors_Item implements IGetInstructors_Item {
  
	public PersonID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOB?: Date;
	public CountryID: number = 0;
	public CountryName: string = "";
	public CountryFullName: string = "";
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public UnitMainAgencyID?: number;
	public Rating?: number;
  
}


