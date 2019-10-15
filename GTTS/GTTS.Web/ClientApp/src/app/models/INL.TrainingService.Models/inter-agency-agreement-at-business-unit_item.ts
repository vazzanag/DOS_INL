

import { IInterAgencyAgreementAtBusinessUnit_Item } from './iinter-agency-agreement-at-business-unit_item';

export class InterAgencyAgreementAtBusinessUnit_Item implements IInterAgencyAgreementAtBusinessUnit_Item {
  
	public InterAgencyAgreementID: number = 0;
	public Code: string = "";
	public Description: string = "";
	public BusinessUnitID: number = 0;
	public Acronym: string = "";
	public BusinessUnitName: string = "";
	public BusinessUnitActive: boolean = false;
	public InterAgencyAgreementBusinessUnitActive: boolean = false;
  
}






