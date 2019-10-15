


import { SaveTrainingEventLocation_Item } from './save-training-event-location_item';
import { SaveTrainingEventUSPartnerAgency_Item } from './save-training-event-uspartner-agency_item';
import { SaveTrainingEventProjectCode_Item } from './save-training-event-project-code_item';

export interface ISaveTrainingEvent_Result {
  
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
	EstimatedStudents?: number;
	FundingSourceID?: number;
	AuthorizingLawID?: number;
	Comments: string;
	TrainingEventLocations?: SaveTrainingEventLocation_Item[];
	TrainingEventUSPartnerAgencies?: SaveTrainingEventUSPartnerAgency_Item[];
	TrainingEventProjectCodes?: SaveTrainingEventProjectCode_Item[];
}





