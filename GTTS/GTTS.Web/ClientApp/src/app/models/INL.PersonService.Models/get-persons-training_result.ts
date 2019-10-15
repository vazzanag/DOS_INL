

import { GetPersonsTraining_Item } from './get-persons-training_item';
import { IGetPersonsTraining_Result } from './iget-persons-training_result';

export class GetPersonsTraining_Result implements IGetPersonsTraining_Result {
  
	public Collection?: GetPersonsTraining_Item[];
  
}


