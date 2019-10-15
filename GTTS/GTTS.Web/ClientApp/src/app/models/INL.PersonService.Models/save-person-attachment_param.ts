

import { ISavePersonAttachment_Param } from './isave-person-attachment_param';

export class SavePersonAttachment_Param implements ISavePersonAttachment_Param {
  
	public PersonID: number = 0;
	public FileID?: number;
	public FileName: string = "";
	public FileVersion?: number;
	public PersonAttachmentType: string = "";
	public Description: string = "";
	public IsDeleted?: boolean;
  
}


