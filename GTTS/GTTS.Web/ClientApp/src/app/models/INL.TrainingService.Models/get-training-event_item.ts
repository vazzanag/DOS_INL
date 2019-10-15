

import { ParticipantCount_Item } from './participant-count_item';
import { GetTrainingEventAppUser_Item } from './get-training-event-app-user_item';
import { GetTrainingEventLocation_Item } from './get-training-event-location_item';
import { GetTrainingEventUSPartnerAgency_Item } from './get-training-event-uspartner-agency_item';
import { GetTrainingEventProjectCode_Item } from './get-training-event-project-code_item';
import { GetTrainingEventStakeholder_Item } from './get-training-event-stakeholder_item';
import { GetTrainingEventAttachment_Item } from './get-training-event-attachment_item';
import { GetTrainingCourseDefinitionProgram_Item } from './get-training-course-definition-program_item';
import { GetTrainingEventKeyActivity_Item } from './get-training-event-key-activity_item';
import { IAA_Item } from './iaa_item';
import { IGetTrainingEvent_Item } from './iget-training-event_item';

export class GetTrainingEvent_Item implements IGetTrainingEvent_Item {
  
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
	public KeyActivityName: string = "";
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
	public ActualBudget?: number;
	public EstimatedStudents?: number;
	public FundingSourceID?: number;
	public AuthorizingLawID?: number;
	public Comments: string = "";
	public ModifiedByAppUserID?: number;
	public ModifiedDate?: Date;
	public TravelStartDate?: Date;
	public TravelEndDate?: Date;
	public EventStartDate?: Date;
	public EventEndDate?: Date;
	public ParticipantCounts?: ParticipantCount_Item[];
	public TrainingEventStatusID?: number;
	public TrainingEventStatus: string = "";
	public Organizer?: GetTrainingEventAppUser_Item;
	public ModifiedBy?: GetTrainingEventAppUser_Item;
	public TrainingEventLocations?: GetTrainingEventLocation_Item[];
	public TrainingEventUSPartnerAgencies?: GetTrainingEventUSPartnerAgency_Item[];
	public TrainingEventProjectCodes?: GetTrainingEventProjectCode_Item[];
	public TrainingEventStakeholders?: GetTrainingEventStakeholder_Item[];
	public TrainingEventAttachments?: GetTrainingEventAttachment_Item[];
	public TrainingEventCourseDefinitionPrograms?: GetTrainingCourseDefinitionProgram_Item[];
	public TrainingEventKeyActivities?: GetTrainingEventKeyActivity_Item[];
	public IAAs?: IAA_Item[];
  
}






