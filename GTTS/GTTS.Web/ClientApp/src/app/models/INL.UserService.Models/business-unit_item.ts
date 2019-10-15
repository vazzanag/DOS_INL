

import { IBusinessUnit_Item } from './ibusiness-unit_item';

export class BusinessUnit_Item implements IBusinessUnit_Item {
  
	public BusinessUnitID: number = 0;
	public BusinessUnitName: string = "";
	public Acronym: string = "";
	public BusinessParentID?: number;
	public PostID?: number;
	public UnitLibraryUnitID?: number;
	public VettingPrefix: string = "";
  
}


