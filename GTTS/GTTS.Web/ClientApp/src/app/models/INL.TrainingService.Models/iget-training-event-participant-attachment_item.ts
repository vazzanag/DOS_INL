



export interface IGetTrainingEventParticipantAttachment_Item {
  
	ParticipantType: string;
	TrainingEventParticipantAttachmentID: number;
	TrainingEventID: number;
	PersonID: number;
	FileID: number;
	FileVersion: number;
	TrainingEventParticipantAttachmentTypeID: number;
	TrainingEventParticipantAttachmentType: string;
	FileName: string;
	FileLocation: string;
	FileHash: number[];
	FileSize: number;
	FileContent: number[];
	ThumbnailPath: string;
	Description: string;
	IsDeleted?: boolean;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	FileJSON: string;
	ModifiedByUserJSON: string;
}





