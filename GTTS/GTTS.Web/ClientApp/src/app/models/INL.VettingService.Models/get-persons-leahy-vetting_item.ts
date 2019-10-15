

import { IGetPersonsLeahyVetting_Item } from './iget-persons-leahy-vetting_item';

export class GetPersonsLeahyVetting_Item implements IGetPersonsLeahyVetting_Item {
  
	public LeahyVettingHitID: number = 0;
	public PersonsVettingID: number = 0;
	public CaseID: string = "";
	public LeahyHitResultID?: number;
	public LeahyHitResult: string = "";
	public LeahyHitAppliesToID?: number;
	public LeahyHitAppliesTo: string = "";
	public ViolationTypeID?: number;
	public CertDate?: Date;
	public ExpiresDate?: Date;
	public Summary: string = "";
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}


