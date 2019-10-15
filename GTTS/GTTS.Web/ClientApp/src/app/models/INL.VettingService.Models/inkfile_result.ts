

import { IINKFile_Result } from './iinkfile_result';

export class INKFile_Result implements IINKFile_Result {
  
	public FileName: string = "";
	public FileContent: number[] = null;
  
	public ErrorMessages: string[] = null;
}


