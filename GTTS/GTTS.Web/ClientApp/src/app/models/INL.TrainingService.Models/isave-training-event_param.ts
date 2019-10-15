


import { SaveTrainingEventLocation_Item } from './save-training-event-location_item';
import { KeyActivity_Item } from './key-activity_item';
import { IAA_Item } from './iaa_item';
import { SaveTrainingEventUSPartnerAgency_Item } from './save-training-event-uspartner-agency_item';
import { SaveTrainingEventProjectCode_Item } from './save-training-event-project-code_item';
import { SaveTrainingEventStakeholder_Item } from './save-training-event-stakeholder_item';

export interface ISaveTrainingEvent_Param {
  
	TrainingEventID?: number;
	Name: string;
	NameInLocalLang: string;
	TrainingEventTypeID: number;
	Justification: string;
	Objectives: string;
	ParticipantProfile: string;
	SpecialRequirements: string;
	ProgramID?: number;
	KeyActivityID?: number;
	TrainingUnitID: number;
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
	Comments: string;
	TrainingEventLocations?: SaveTrainingEventLocation_Item[];
	KeyActivities?: KeyActivity_Item[];
	IAAs?: IAA_Item[];
	TrainingEventUSPartnerAgencies?: SaveTrainingEventUSPartnerAgency_Item[];
	TrainingEventProjectCodes?: SaveTrainingEventProjectCode_Item[];
	TrainingEventStakeholders?: SaveTrainingEventStakeholder_Item[];
}





