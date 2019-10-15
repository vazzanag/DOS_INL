

import { IParticipantAttachment } from './iparticipant-attachment';

export class ParticipantAttachment implements IParticipantAttachment {
  
	public PersonID: number = 0;
	public FileID: number = 0;
	public FileName: string = "";
	public FileLocation: string = "";
	public PersonAttachmentTypeID: number = 0;
	public PersonAttachmentType: string = "";
	public Description: string = "";
	public IsDeleted?: boolean;
	public ModifiedByAppUserID: number = 0;
	public FullName: string = "";
	public ModifiedDate: Date = new Date(0);
  
}


