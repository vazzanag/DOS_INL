


import { GetPersonsVettingHit_Item } from './get-persons-vetting-hit_item';

export interface IGetPersonsVettingHit_Result {
  
	PersonsVettingID: number;
	VettingTypeID: number;
	HitResultID: number;
	HitResultDetails: string;
	items?: GetPersonsVettingHit_Item[];

}

