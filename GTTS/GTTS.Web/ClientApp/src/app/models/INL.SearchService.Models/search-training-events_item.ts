

import { SearchTrainingEventLocations_Item } from './search-training-event-locations_item';
import { SearchTrainingEventKeyActivities_Item } from './search-training-event-key-activities_item';
import { ISearchTrainingEvents_Item } from './isearch-training-events_item';

export class SearchTrainingEvents_Item implements ISearchTrainingEvents_Item {
  
	public TrainingEventID: number = 0;
	public Name: string = "";
	public NameInLocalLang: string = "";
	public CountryID: number = 0;
	public TrainingUnitID?: number;
	public TrainingUnitAcronym: string = "";
	public TrainingUnit: string = "";
	public OrganizerAppUserID?: number;
	public OrganizerFullName: string = "";
	public ParticipantCount: number = 0;
	public TrainingEventType: string = "";
	public TrainingEventStatusID?: number;
	public TrainingEventStatus: string = "";
	public EventStartDate?: Date;
	public EventEndDate?: Date;
	public Locations?: SearchTrainingEventLocations_Item[];
	public KeyActivities?: SearchTrainingEventKeyActivities_Item[];
  
}


