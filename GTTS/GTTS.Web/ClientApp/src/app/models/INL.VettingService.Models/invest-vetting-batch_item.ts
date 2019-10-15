

import { IInvestVettingBatch_Item } from './iinvest-vetting-batch_item';

export class InvestVettingBatch_Item implements IInvestVettingBatch_Item {
  
	public VettingBatchID: number = 0;
	public PersonsVettingID: number = 0;
	public PersonID: number = 0;
	public Name1: string = "";
	public Name2: string = "";
	public Name3: string = "";
	public Name4: string = "";
	public Name5: string = "";
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public FatherName: string = "";
	public MotherName: string = "";
	public DOB?: Date;
	public Gender: string = "";
	public NationalID: string = "";
	public POBCityName: string = "";
	public POBStateName: string = "";
	public POBCountryName: string = "";
	public UnitName: string = "";
	public UnitType: string = "";
	public JobTitle: string = "";
	public RankName: string = "";
	public ModifiedDate: Date = new Date(0);
	public UnitAliasJson: string = "";
  
}


