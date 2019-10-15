

import { IUnit_Item } from './iunit_item';
import { IUpdateUnitParent_Result } from './iupdate-unit-parent_result';

export class UpdateUnitParent_Result implements IUpdateUnitParent_Result {
  
	public UnitItem?: IUnit_Item;
  
	public ErrorMessages: string[] = null;
}


