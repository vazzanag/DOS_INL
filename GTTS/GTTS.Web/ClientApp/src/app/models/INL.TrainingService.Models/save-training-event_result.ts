

import { SaveTrainingEventLocation_Item } from './save-training-event-location_item';
import { SaveTrainingEventUSPartnerAgency_Item } from './save-training-event-uspartner-agency_item';
import { SaveTrainingEventProjectCode_Item } from './save-training-event-project-code_item';
import { SaveTrainingEventStakeholder_Item } from './save-training-event-stakeholder_item';
import { ISaveTrainingEvent_Result } from './isave-training-event_result';

export class SaveTrainingEvent_Result implements ISaveTrainingEvent_Result {
  
	public TrainingEventID: number = 0;
	public Name: string = "";
	public NameInLocalLang: string = "";
	public TrainingEventTypeID: number = 0;
	public TrainingEventTypeName: string = "";
	public Justification: string = "";
	public Objectives: string = "";
	public ParticipantProfile: string = "";
	public SpecialRequirements: string = "";
	public ProgramID?: number;
	public KeyActivityID?: number;
	public TrainingUnitID?: number;
	public BusinessUnitAcronym: string = "";
	public BusinessUnitName: string = "";
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
	public EstimatedStudents?: number;
	public FundingSourceID?: number;
	public AuthorizingLawID?: number;
	public Comments: string = "";
	public TrainingEventLocations?: SaveTrainingEventLocation_Item[];
	public TrainingEventUSPartnerAgencies?: SaveTrainingEventUSPartnerAgency_Item[];
	public TrainingEventProjectCodes?: SaveTrainingEventProjectCode_Item[];
	public TrainingEventStakeholders?: SaveTrainingEventStakeholder_Item[];
  
}






