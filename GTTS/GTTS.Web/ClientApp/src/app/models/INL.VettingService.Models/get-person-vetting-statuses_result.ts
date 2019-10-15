

import { PersonVettingStatus_Item } from './person-vetting-status_item';
import { IGetPersonVettingStatuses_Result } from './iget-person-vetting-statuses_result';

export class GetPersonVettingStatuses_Result implements IGetPersonVettingStatuses_Result {
  
	public Collection?: PersonVettingStatus_Item[];
  
}


