

import { IRemovedParticipant_Item } from './iremoved-participant_item';

export class RemovedParticipant_Item implements IRemovedParticipant_Item {
  
	public PersonID: number = 0;
	public RemovedFromEvent: boolean = false;
	public RemovedFromVetting: boolean = false;
  
}


