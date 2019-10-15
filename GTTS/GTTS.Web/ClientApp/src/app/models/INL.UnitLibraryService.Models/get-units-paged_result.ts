

import { IUnit_Item } from './iunit_item';
import { IGetUnitsPaged_Result } from './iget-units-paged_result';

export class GetUnitsPaged_Result implements IGetUnitsPaged_Result {
  
	public Collection?: IUnit_Item[];
  
}


