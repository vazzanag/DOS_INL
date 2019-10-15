import { FileAttachment } from "./file-attachment";

export class TrainingEventStudentAttachment {
    public TrainingEventStudentAttachmentID: number = 0;
    public TrainingEventID: number = 0;
    public PersonID: number = 0;
    public FileVersion: number = 0;
    public TrainingEventStudentAttachmentTypeID: number = 0;
    public TrainingEventStudentAttachmentType: string = "";
    public FileName: string = "";
    public FileSize: number = 0;
    public FileHash: number[] = null;
    public ThumbnailPath: string = "";
    public Description: string = "";
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);
    public ModifiedByUserJSON: string = "";


    public AsFileAttachment(): FileAttachment {
        let attachment = new FileAttachment();
        attachment.ID = this.TrainingEventStudentAttachmentID;
        attachment.AttachmentType = this.TrainingEventStudentAttachmentType;
        attachment.FileName = this.FileName;
        attachment.FileSize = this.FileSize;
        attachment.ThumbnailPath = this.ThumbnailPath;
        attachment.Description = this.Description;
        attachment.DownloadURL = this.Description;

        return attachment;
    }
}
