


import { GetTrainingEventAppUser_Item } from './get-training-event-app-user_item';
import { GetTrainingEventLocation_Item } from './get-training-event-location_item';
import { GetTrainingEventUSPartnerAgency_Item } from './get-training-event-uspartner-agency_item';
import { GetTrainingEventProjectCode_Item } from './get-training-event-project-code_item';
import { GetTrainingEventStakeholder_Item } from './get-training-event-stakeholder_item';
import { GetTrainingEventAttachment_Item } from './get-training-event-attachment_item';

export interface IGetTrainingEvents_Item {
  
	TrainingEventID: number;
	Name: string;
	NameInLocalLang: string;
	TrainingEventTypeID: number;
	TrainingEventTypeName: string;
	Justification: string;
	Objectives: string;
	ParticipantProfile: string;
	SpecialRequirements: string;
	ProgramID?: number;
	KeyActivityID?: number;
	KeyActivityName: string;
	TrainingUnitID?: number;
	BusinessUnitAcronym: string;
	BusinessUnitName: string;
	CountryID?: number;
	PostID?: number;
	ConsularDistrictID?: number;
	OrganizerAppUserID?: number;
	PlannedParticipantCnt?: number;
	PlannedMissionDirectHireCnt?: number;
	PlannedNonMissionDirectHireCnt?: number;
	PlannedMissionOutsourceCnt?: number;
	PlannedOtherCnt?: number;
	EstimatedBudget?: number;
	ActualBudget?: number;
	EstimatedStudents?: number;
	FundingSourceID?: number;
	AuthorizingLawID?: number;
	ModifiedByAppUserID?: number;
	ModifiedDate?: Date;
	TravelStartDate?: Date;
	TravelEndDate?: Date;
	EventStartDate?: Date;
	EventEndDate?: Date;
	StudentCount?: number;
	InstructorCount?: number;
	TrainingEventStatusID?: number;
	TrainingEventStatus: string;
	Organizer?: GetTrainingEventAppUser_Item;
	ModifiedBy?: GetTrainingEventAppUser_Item;
	TrainingEventLocations?: GetTrainingEventLocation_Item[];
	TrainingEventUSPartnerAgencies?: GetTrainingEventUSPartnerAgency_Item[];
	TrainingEventProjectCodes?: GetTrainingEventProjectCode_Item[];
	TrainingEventStakeholders?: GetTrainingEventStakeholder_Item[];
	TrainingEventAttachments?: GetTrainingEventAttachment_Item[];

}

