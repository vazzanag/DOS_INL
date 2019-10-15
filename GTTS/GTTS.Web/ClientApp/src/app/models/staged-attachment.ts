export class StagedAttachment
{
    public ContextID: number = 0;
    public FileID?: number;
    public FileName: string = "";
    public FileVersion?: number;
    public AttachmentType: string = "";
    public Description: string = "";
    public IsDeleted?: boolean;
    public Content: File;
}