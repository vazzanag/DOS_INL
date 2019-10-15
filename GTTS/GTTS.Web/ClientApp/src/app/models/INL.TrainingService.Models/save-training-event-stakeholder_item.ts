

import { ISaveTrainingEventStakeholder_Item } from './isave-training-event-stakeholder_item';

export class SaveTrainingEventStakeholder_Item implements ISaveTrainingEventStakeholder_Item {
  
	public TrainingEventID?: number;
	public AppUserID?: number;
	public ModifiedByAppUserID?: number;
	public ModifiedDate: Date = new Date(0);
  
}






