

import { GetTrainingEventBatchParticipants_Item } from './get-training-event-batch-participants_item';
import { IGetTrainingEventBatch_Item } from './iget-training-event-batch_item';

export class GetTrainingEventBatch_Item implements IGetTrainingEventBatch_Item {
  
	public BatchNumber: number = 0;
	public Participants?: GetTrainingEventBatchParticipants_Item[];
  
}






