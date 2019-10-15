

import { GetPersonsVetting_Item } from './get-persons-vetting_item';
import { IGetPersonsVettings_Result } from './iget-persons-vettings_result';

export class GetPersonsVettings_Result implements IGetPersonsVettings_Result {
  
	public VettingCollection?: GetPersonsVetting_Item[];
  
}


