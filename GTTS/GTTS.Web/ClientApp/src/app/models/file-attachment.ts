export class FileAttachment {
    public ID: number = 0;
    public AttachmentType: string = "";
    public FileName: string = "";
    public FileSize: number = 0;
    public get FileSizeAsString(): string {
        if (this.FileSize < 0) return "0B";

        let sizeNumber = this.FileSize;
        let magnitude = 0;

        while (sizeNumber > 1024) {
            sizeNumber = Math.round(sizeNumber / 1024);
            magnitude++;
        }

        let notation = "";
        switch (magnitude) {
            case 0: notation = "B"; break;
            case 1: notation = "KB"; break;
            case 2: notation = "MB"; break;
            case 3: notation = "GB"; break;
        }

        return "" + sizeNumber + notation;
    };
    public ThumbnailPath: string = "";
    public Description: string = "";
    public DownloadURL: string = "";

}
