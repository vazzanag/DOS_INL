

import { IGetPerson_Item } from './iget-person_item';

export class GetPerson_Item implements IGetPerson_Item {
  
	public PersonID: number = 0;
	public CountryID: number = 0;
	public FullName: string = "";
	public Gender: string = "";
	public AgencyName: string = "";
	public RankName: string = "";
	public JobTitle: string = "";
	public IsUSCitizen?: boolean;
	public NationalID: string = "";
	public ContactEmail: string = "";
	public ContactPhone: string = "";
	public DOB?: Date;
	public PlaceOfBirth: string = "";
	public PlaceOfResidence: string = "";
	public EducationLevel: string = "";
	public PersonLanguagesJSON: string = "";
  
}


