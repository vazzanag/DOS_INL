


export class MessageThreadMessage_Item  {
  
	public MessageThreadMessageID?: number;
	public MessageThreadID: number = 0;
	public SenderAppUserID: number = 0;
	public SenderAppUserFirst: string = "";
	public SenderAppUserMiddle: string = "";
	public SenderAppUserLast: string = "";
	public SentTime: Date = new Date(0);
	public Message: string = "";
	public AttachmentFileID?: number;
	public AttachmentFileName: string = "";
	public AttachmentFileLocation: string = "";
	public AttachmentFileHash: number[] = null;
	public AttachmentFileThumbnailPath: string = "";
	public AttachmentFileSize?: number;
	public AttachmentFileTypeID?: number;
	public AttachmentFileType: string = "";
  
}


