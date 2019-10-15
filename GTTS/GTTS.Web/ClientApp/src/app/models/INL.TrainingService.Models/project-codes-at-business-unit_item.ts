

import { IProjectCodesAtBusinessUnit_Item } from './iproject-codes-at-business-unit_item';

export class ProjectCodesAtBusinessUnit_Item implements IProjectCodesAtBusinessUnit_Item {
  
	public ProjectCodeID: number = 0;
	public Code: string = "";
	public Description: string = "";
	public BusinessUnitID: number = 0;
	public Acronym: string = "";
	public BusinessUnitName: string = "";
	public BusinessUnitActive: boolean = false;
	public ProjectCodeBusinessUnitActive: boolean = false;
  
}






