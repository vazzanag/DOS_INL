

import { ICourtesyBatch_Item } from './icourtesy-batch_item';
import { IGetCourtesyBatch_Result } from './iget-courtesy-batch_result';

export class GetCourtesyBatch_Result implements IGetCourtesyBatch_Result {
  
	public item?: ICourtesyBatch_Item;
  
	public ErrorMessages: string[] = null;
}


