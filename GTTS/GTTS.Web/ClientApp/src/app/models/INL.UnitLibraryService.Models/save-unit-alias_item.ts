

import { ISaveUnitAlias_Item } from './isave-unit-alias_item';

export class SaveUnitAlias_Item implements ISaveUnitAlias_Item {
  
	public UnitAliasID: number = 0;
	public UnitID: number = 0;
	public UnitAlias: string = "";
	public LanguageID?: number;
	public ModifiedByAppUserID: number = 0;
	public IsDefault: boolean = false;
	public IsActive: boolean = false;
  
}


