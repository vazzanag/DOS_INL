

import { ISaveUnitCommander_Item } from './isave-unit-commander_item';

export class SaveUnitCommander_Item implements ISaveUnitCommander_Item {
  
	public PersonID?: number;
	public UnitID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender: string = "";
	public ModifiedByAppUserID: number = 0;
  
}


