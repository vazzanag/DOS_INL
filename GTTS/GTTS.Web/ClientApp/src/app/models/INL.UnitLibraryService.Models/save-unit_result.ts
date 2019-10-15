

import { IUnit_Item } from './iunit_item';
import { ISaveUnit_Result } from './isave-unit_result';

export class SaveUnit_Result implements ISaveUnit_Result {
  
	public UnitItem?: IUnit_Item;
  
	public ErrorMessages: string[] = null;
}


