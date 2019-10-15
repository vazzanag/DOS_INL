

import { IGetMatchingPersons_Param } from './iget-matching-persons_param';

export class GetMatchingPersons_Param implements IGetMatchingPersons_Param {
  
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOB?: Date;
	public POBCityID?: number;
	public Gender?: string;
	public NationalID: string = "";
	public ExactMatch?: boolean;
  
}


