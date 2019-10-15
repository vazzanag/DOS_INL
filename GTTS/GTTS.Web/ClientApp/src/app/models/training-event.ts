import { TrainingEventLocation } from '@models/training-event-location';
import { TrainingEventProjectCode } from '@models/training-event-project-code';
import { TrainingEventUSPartnerAgency } from '@models/training-event-uspartner-agency';
import { TrainingEventIAA } from '@models/training-event-iaa';
import { TrainingEventStakeholder } from '@models/training-event-stakeholder';
import { TrainingEventAppUser } from '@models/training-event-appuser';
import { TrainingEventAttachment } from '@models/training-event-attachment';
import { TrainingEventParticipantCount } from '@models/training-event-participant-count';
import { GetTrainingCourseDefinitionProgram_Item } from './INL.TrainingService.Models/get-training-course-definition-program_item';
import { GetTrainingEventKeyActivity_Item } from './INL.TrainingService.Models/get-training-event-key-activity_item';

export class TrainingEvent {
    public TrainingEventID?: number;
    public Name: string = "";
    public NameInLocalLang: string = "";
    public TrainingEventTypeID: number;
    public EventStartDate: Date;
    public EventEndDate: Date;
    public TravelStartDate?: Date;
    public TravelEndDate?: Date;
    public TrainingEventTypeName: string = "";
    public Justification: string = "";
    public Objectives: string = "";
    public ParticipantProfile: string = "";
    public SpecialRequirements: string = "";
    public ProgramID?: number;
    public KeyActivityID?: number;
    public KeyActivityName: string;
    public TrainingUnitID: number = 0;
    public BusinessUnitAcronym: string = "";
    public BusinessUnitName: string = "";
    public CountryID?: number;
    public PostID?: number;
    public ConsularDistrictID?: number;
    public OrganizerAppUserID?: number;
    public PlannedParticipantCnt: number;
    public PlannedMissionDirectHireCnt: number;
    public PlannedNonMissionDirectHireCnt: number;
    public PlannedMissionOutsourceCnt: number;
    public PlannedOtherCnt: number;
    public EstimatedBudget?: number;
    public ActualBudget?: number;
    public EstimatedStudents?: number;
    public FundingSourceID?: number;
    public AuthorizingLawID?: number;
    public Comments: string;
    public CreatedDate?: Date;
    public ModifiedByAppUserID?: number;
    public TrainingEventStatusID?: number;
    public TrainingEventStatus: string = "";
    public TotalParticipants: number;
    public ParticipantCounts?: TrainingEventParticipantCount[];
    public Organizer?: TrainingEventAppUser;
    public OrganizerName: string;
    public ModifiedBy?: TrainingEventAppUser;
    public ModifiedByAppUser: string;
    public ModifiedDate?: Date;
    public TrainingEventLocations?: TrainingEventLocation[];
    public TrainingEventUSPartnerAgencies?: TrainingEventUSPartnerAgency[];
    public TrainingEventProjectCodes?: TrainingEventProjectCode[];
    public TrainingEventIIAs?: TrainingEventIAA[];
    public TrainingEventStakeholders?: TrainingEventStakeholder[];
    public TrainingEventAttachments?: TrainingEventAttachment[];
    public Location: string = "";
    public TrainingEventCourseDefinitionPrograms?: GetTrainingCourseDefinitionProgram_Item[];
    public TrainingEventKeyActivities?: GetTrainingEventKeyActivity_Item[];
    public CoursePrograms: string = "";
    public ProjectCodes: string = "";


    constructor() {
        this.Organizer = new TrainingEventAppUser();
        this.ModifiedBy = new TrainingEventAppUser();

        this.TrainingEventLocations = [];
        this.TrainingEventUSPartnerAgencies = [];
        this.TrainingEventProjectCodes = [];
        this.TrainingEventStakeholders = [];
        this.TrainingEventAttachments = [];
        this.ParticipantCounts = [];
        this.TrainingEventCourseDefinitionPrograms = [];
        this.TrainingEventKeyActivities = [];
    }
}
