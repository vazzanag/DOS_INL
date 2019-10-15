

import { IGetUnitLocation_Item } from './iget-unit-location_item';

export class GetUnitLocation_Item implements IGetUnitLocation_Item {
  
	public LocationID: number = 0;
	public LocationName: string = "";
	public AddressLine1: string = "";
	public AddressLine2: string = "";
	public AddressLine3: string = "";
	public StateID: number = 0;
	public CityID: number = 0;
	public IsActive: boolean = false;
	public ModifiedByAppUserID: number = 0;
  
}


