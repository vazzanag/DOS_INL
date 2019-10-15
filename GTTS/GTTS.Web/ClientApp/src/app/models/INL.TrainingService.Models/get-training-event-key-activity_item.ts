

import { IGetTrainingEventKeyActivity_Item } from './iget-training-event-key-activity_item';

export class GetTrainingEventKeyActivity_Item implements IGetTrainingEventKeyActivity_Item {
  
	public KeyActivityID: number = 0;
	public TrainingEventID: number = 0;
	public Code: string = "";
	public Description: string = "";
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}






