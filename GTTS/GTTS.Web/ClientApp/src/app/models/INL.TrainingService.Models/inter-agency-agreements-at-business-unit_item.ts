

import { IInterAgencyAgreementsAtBusinessUnit_Item } from './iinter-agency-agreements-at-business-unit_item';

export class InterAgencyAgreementsAtBusinessUnit_Item implements IInterAgencyAgreementsAtBusinessUnit_Item {
  
	public InterAgencyAgreementID: number = 0;
	public Code: string = "";
	public Description: string = "";
	public BusinessUnitID: number = 0;
	public Acronym: string = "";
	public BusinessUnitName: string = "";
	public BusinessUnitActive: boolean = false;
	public InterAgencyAgreementBusinessUnitActive: boolean = false;
  
}






