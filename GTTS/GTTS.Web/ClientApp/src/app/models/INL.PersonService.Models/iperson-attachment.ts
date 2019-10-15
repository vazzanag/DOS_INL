



export interface IPersonAttachment {
  
	PersonID: number;
	FileID: number;
	FileName: string;
	FileLocation: string;
	PersonAttachmentTypeID: number;
	PersonAttachmentType: string;
	Description: string;
	IsDeleted?: boolean;
	ModifiedByAppUserID: number;
	FullName: string;
	ModifiedDate: Date;
	FileContent: number[];
	FileHash: number[];
	FileSize: number;

}

