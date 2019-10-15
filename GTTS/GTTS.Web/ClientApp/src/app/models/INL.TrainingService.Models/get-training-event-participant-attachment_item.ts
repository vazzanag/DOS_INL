

import { IGetTrainingEventParticipantAttachment_Item } from './iget-training-event-participant-attachment_item';

export class GetTrainingEventParticipantAttachment_Item implements IGetTrainingEventParticipantAttachment_Item {
  
	public ParticipantType: string = "";
	public TrainingEventParticipantAttachmentID: number = 0;
	public TrainingEventID: number = 0;
	public PersonID: number = 0;
	public FileID: number = 0;
	public FileVersion: number = 0;
	public TrainingEventParticipantAttachmentTypeID: number = 0;
	public TrainingEventParticipantAttachmentType: string = "";
	public FileName: string = "";
	public FileLocation: string = "";
	public FileHash: number[] = null;
	public FileSize: number = 0;
	public FileContent: number[] = null;
	public ThumbnailPath: string = "";
	public Description: string = "";
	public IsDeleted?: boolean;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public FileJSON: string = "";
	public ModifiedByUserJSON: string = "";
  
}






