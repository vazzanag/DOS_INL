

import { ISaveUnitLocation_Item } from './isave-unit-location_item';

export class SaveUnitLocation_Item implements ISaveUnitLocation_Item {
  
	public CityID: number = 0;
	public Address1: string = "";
	public Address2: string = "";
	public Address3: string = "";
	public ModifiedByAppUserID: number = 0;
	public CountryID?: number;
	public StateID?: number;
  
}


