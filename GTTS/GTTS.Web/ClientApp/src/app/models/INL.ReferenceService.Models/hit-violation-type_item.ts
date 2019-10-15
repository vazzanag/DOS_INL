

import { IHitViolationType_Item } from './ihit-violation-type_item';

export class HitViolationType_Item implements IHitViolationType_Item {
  
	public ViolationTypeID: number = 0;
	public Code: string = "";
	public Description: string = "";
	public IsActive: boolean = false;
  
}


