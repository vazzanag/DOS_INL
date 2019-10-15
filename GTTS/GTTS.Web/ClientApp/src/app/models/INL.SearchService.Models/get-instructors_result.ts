

import { IGetInstructors_Item } from './iget-instructors_item';
import { IGetInstructors_Result } from './iget-instructors_result';

export class GetInstructors_Result implements IGetInstructors_Result {
  
	public Collection?: IGetInstructors_Item[];
  
}


