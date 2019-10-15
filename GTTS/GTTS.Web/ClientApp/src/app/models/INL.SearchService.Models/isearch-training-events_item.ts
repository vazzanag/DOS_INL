


import { SearchTrainingEventLocations_Item } from './search-training-event-locations_item';
import { SearchTrainingEventKeyActivities_Item } from './search-training-event-key-activities_item';

export interface ISearchTrainingEvents_Item {
  
	TrainingEventID: number;
	Name: string;
	NameInLocalLang: string;
	CountryID: number;
	TrainingUnitID?: number;
	TrainingUnitAcronym: string;
	TrainingUnit: string;
	OrganizerAppUserID?: number;
	OrganizerFullName: string;
	ParticipantCount: number;
	TrainingEventType: string;
	TrainingEventStatusID?: number;
	TrainingEventStatus: string;
	EventStartDate?: Date;
	EventEndDate?: Date;
	Locations?: SearchTrainingEventLocations_Item[];
	KeyActivities?: SearchTrainingEventKeyActivities_Item[];

}

