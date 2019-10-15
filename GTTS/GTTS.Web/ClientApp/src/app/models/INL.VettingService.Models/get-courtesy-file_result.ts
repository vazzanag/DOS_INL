

import { IGetCourtesyFile_Result } from './iget-courtesy-file_result';

export class GetCourtesyFile_Result implements IGetCourtesyFile_Result {
  
	public FileID: number = 0;
	public FileVersion: number = 0;
	public FileName: string = "";
	public FileSize: number = 0;
	public FileHash: number[] = null;
	public FileContent: number[] = null;
  
	public ErrorMessages: string[] = null;
}


