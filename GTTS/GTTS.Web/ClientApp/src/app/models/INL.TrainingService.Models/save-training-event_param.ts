

import { SaveTrainingEventLocation_Item } from './save-training-event-location_item';
import { KeyActivity_Item } from './key-activity_item';
import { IAA_Item } from './iaa_item';
import { SaveTrainingEventUSPartnerAgency_Item } from './save-training-event-uspartner-agency_item';
import { SaveTrainingEventProjectCode_Item } from './save-training-event-project-code_item';
import { SaveTrainingEventStakeholder_Item } from './save-training-event-stakeholder_item';
import { ISaveTrainingEvent_Param } from './isave-training-event_param';

export class SaveTrainingEvent_Param implements ISaveTrainingEvent_Param {
  
	public TrainingEventID?: number;
	public Name: string = "";
	public NameInLocalLang: string = "";
	public TrainingEventTypeID: number = 0;
	public Justification: string = "";
	public Objectives: string = "";
	public ParticipantProfile: string = "";
	public SpecialRequirements: string = "";
	public ProgramID?: number;
	public KeyActivityID?: number;
	public TrainingUnitID: number = 0;
	public CountryID?: number;
	public PostID?: number;
	public ConsularDistrictID?: number;
	public OrganizerAppUserID?: number;
	public PlannedParticipantCnt?: number;
	public PlannedMissionDirectHireCnt?: number;
	public PlannedNonMissionDirectHireCnt?: number;
	public PlannedMissionOutsourceCnt?: number;
	public PlannedOtherCnt?: number;
	public EstimatedBudget?: number;
	public ActualBudget?: number;
	public EstimatedStudents?: number;
	public FundingSourceID?: number;
	public AuthorizingLawID?: number;
	public Comments: string = "";
	public TrainingEventLocations?: SaveTrainingEventLocation_Item[];
	public KeyActivities?: KeyActivity_Item[];
	public IAAs?: IAA_Item[];
	public TrainingEventUSPartnerAgencies?: SaveTrainingEventUSPartnerAgency_Item[];
	public TrainingEventProjectCodes?: SaveTrainingEventProjectCode_Item[];
	public TrainingEventStakeholders?: SaveTrainingEventStakeholder_Item[];
  
}






