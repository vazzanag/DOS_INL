

import { IGetUnitAlias_Item } from './iget-unit-alias_item';

export class GetUnitAlias_Item implements IGetUnitAlias_Item {
  
	public UnitAliasID: number = 0;
	public UnitID: number = 0;
	public UnitAlias: string = "";
	public LanguageID?: number;
	public IsDefault: boolean = false;
	public IsActive: boolean = false;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}


