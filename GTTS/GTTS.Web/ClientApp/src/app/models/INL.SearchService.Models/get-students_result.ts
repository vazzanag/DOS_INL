

import { IGetStudents_Item } from './iget-students_item';
import { IGetStudents_Result } from './iget-students_result';

export class GetStudents_Result implements IGetStudents_Result {
  
	public Collection?: IGetStudents_Item[];
  
}


