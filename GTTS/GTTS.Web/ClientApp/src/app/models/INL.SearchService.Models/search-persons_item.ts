

import { ISearchPersons_Item } from './isearch-persons_item';

export class SearchPersons_Item implements ISearchPersons_Item {
  
	public PersonID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public ParticipantType: string = "";
	public VettingStatus: string = "";
	public VettingStatusDate?: Date;
	public VettingTypeCode: string = "";
	public UnitID?: number;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public AgencyName: string = "";
	public AgencyNameEnglish: string = "";
	public DOB?: Date;
	public Distinction: string = "";
	public Gender: string = "";
	public JobRank: string = "";
	public JobTitle: string = "";
	public CountryID?: number;
	public CountryName: string = "";
	public VettingValidEndDate?: Date;
	public RowNumber: number = 0;
  
}


