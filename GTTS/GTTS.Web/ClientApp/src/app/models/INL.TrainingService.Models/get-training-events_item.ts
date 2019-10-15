

import { GetTrainingEventLocation_Item } from './get-training-event-location_item';
import { GetTrainingEventKeyActivity_Item } from './get-training-event-key-activity_item';

export class GetTrainingEvents_Item  {
  
	public TrainingEventID: number = 0;
	public Name: string = "";
	public NameInLocalLang: string = "";
	public TrainingEventType: string = "";
	public ProgramID?: number;
	public BusinessUnitAcronym: string = "";
	public BusinessUnit: string = "";
	public OrganizerAppUserID?: number;
	public Organizer: string = "";
	public TrainingEventStatusID?: number;
	public TrainingEventStatus: string = "";
	public EventStartDate?: Date;
	public EventEndDate?: Date;
	public ModifiedByAppUserID?: number;
	public ModifiedByAppUser: string = "";
	public ModifiedDate?: Date;
	public CreatedDate?: Date;
	public TrainingEventLocations?: GetTrainingEventLocation_Item[];
	public TrainingEventKeyActivities?: GetTrainingEventKeyActivity_Item[];
  
}






