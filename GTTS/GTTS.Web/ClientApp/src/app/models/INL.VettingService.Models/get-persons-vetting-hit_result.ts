

import { GetPersonsVettingHit_Item } from './get-persons-vetting-hit_item';
import { IGetPersonsVettingHit_Result } from './iget-persons-vetting-hit_result';

export class GetPersonsVettingHit_Result implements IGetPersonsVettingHit_Result {
  
	public PersonsVettingID: number = 0;
	public VettingTypeID: number = 0;
	public HitResultID: number = 0;
	public HitResultDetails: string = "";
	public items?: GetPersonsVettingHit_Item[];
  
	public ErrorMessages: string[] = null;
}


