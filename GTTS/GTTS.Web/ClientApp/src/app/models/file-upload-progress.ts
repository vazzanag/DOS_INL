export class FileUploadProgress {
  public FileName: string = "";
  public Total: number = 0;
  public Loaded: number = 0;
  public static Percent(progress: FileUploadProgress): number {
    return Math.round(100 * progress.Loaded / progress.Total);
  }
};
