
import { FileAttachment } from '@models/file-attachment';

export class TrainingEventAttachment {
    public TrainingEventAttachmentID: number = 0;
    public TrainingEventID: number = 0;
    public FileVersion: number = 0;
    public TrainingEventAttachmentTypeID: number = 0;
    public TrainingEventAttachmentType: string = "";
    public FileName: string = "";
    public FileSize: number = 0;
    public FileHash: number[] = null;
    public ThumbnailPath: string = "";
    public Description: string = "";
    public IsDeleted?: boolean;
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);
    public ModifiedByUserJSON: string = "";


    public AsFileAttachment(): FileAttachment {
        let attachment = new FileAttachment();
        attachment.ID = this.TrainingEventAttachmentID;
        attachment.AttachmentType = this.TrainingEventAttachmentType;
        attachment.FileName = this.FileName;
        attachment.FileSize = this.FileSize;
        attachment.ThumbnailPath = this.ThumbnailPath;
        attachment.Description = this.Description;
        attachment.DownloadURL = this.Description;

        return attachment;
    }
}
