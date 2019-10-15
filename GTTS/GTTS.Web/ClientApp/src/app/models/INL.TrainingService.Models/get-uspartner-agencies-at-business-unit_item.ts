

import { IGetUSPartnerAgenciesAtBusinessUnit_Item } from './iget-uspartner-agencies-at-business-unit_item';

export class GetUSPartnerAgenciesAtBusinessUnit_Item implements IGetUSPartnerAgenciesAtBusinessUnit_Item {
  
	public AgencyID: number = 0;
	public Name: string = "";
	public BusinessUnitID: number = 0;
	public Acronym: string = "";
	public BusinessUnitName: string = "";
	public BusinessUnitActive: boolean = false;
	public USPartnerAgenciesBusinessUnitActive: boolean = false;
  
}






