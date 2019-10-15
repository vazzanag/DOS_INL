

import { IKeyActivitiesAtBusinessUnit_Item } from './ikey-activities-at-business-unit_item';

export class KeyActivitiesAtBusinessUnit_Item implements IKeyActivitiesAtBusinessUnit_Item {
  
	public KeyActivityID: number = 0;
	public Code: string = "";
	public BusinessUnitID: number = 0;
	public Acronym: string = "";
	public BusinessUnitName: string = "";
	public BusinessUnitActive: boolean = false;
	public KeyActivityBusinessUnitActive: boolean = false;
  
}






