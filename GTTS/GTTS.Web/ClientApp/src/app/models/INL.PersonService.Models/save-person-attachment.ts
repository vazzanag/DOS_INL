

import { ISavePersonAttachment } from './isave-person-attachment';

export class SavePersonAttachment implements ISavePersonAttachment {
  
	public PersonID?: number;
	public FileID?: number;
	public FileVersion?: number;
	public PersonAttachmentTypeID?: number;
	public Description: string = "";
	public IsDeleted?: boolean;
	public ModifiedByAppUserID?: number;
  
}


