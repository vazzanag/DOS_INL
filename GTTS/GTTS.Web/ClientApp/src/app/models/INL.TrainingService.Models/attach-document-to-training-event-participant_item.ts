

import { IAttachDocumentToTrainingEventParticipant_Item } from './iattach-document-to-training-event-participant_item';

export class AttachDocumentToTrainingEventParticipant_Item implements IAttachDocumentToTrainingEventParticipant_Item {
  
	public TrainingEventStudentAttachmentID: number = 0;
	public TrainingEventID: number = 0;
	public PersonID: number = 0;
	public FileVersion: number = 0;
	public TrainingEventStudentAttachmentTypeID: number = 0;
	public TrainingEventStudentAttachmentType: string = "";
	public FileName: string = "";
	public Description: string = "";
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}






