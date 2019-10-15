

import { IBaseFileAttachment_Item } from './ibase-file-attachment_item';

export class BaseFileAttachment_Item implements IBaseFileAttachment_Item {
  
	public FileID: number = 0;
	public FileName: string = "";
	public FileSize: number = 0;
	public FileHash: number[] = null;
	public FileContent: number[] = null;
	public ModifiedByAppUserID: number = 0;
  
}


