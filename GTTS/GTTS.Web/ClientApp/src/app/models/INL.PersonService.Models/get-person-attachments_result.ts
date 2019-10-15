

import { PersonAttachment } from './person-attachment';
import { IGetPersonAttachments_Result } from './iget-person-attachments_result';

export class GetPersonAttachments_Result implements IGetPersonAttachments_Result {
  
	public Collection?: PersonAttachment[];
  
}


