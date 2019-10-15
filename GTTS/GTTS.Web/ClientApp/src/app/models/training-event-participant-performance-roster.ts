import { TrainingEventParticipantAttendance } from './training-event-participant-attendance';

export class TrainingEventParticipantPerformanceRoster
{
    public TrainingEventRosterID?: number;
    public TrainingEventID: number = 0;
    public PersonID: number = 0;
    public FirstMiddleNames: string = "";
    public LastNames: string = "";
    public ParticipantType: string = "";
    public PreTestScore?: number;
    public PostTestScore?: number;
    public PerformanceScore?: number;
    public ProductsScore?: number;
    public AttendanceScore?: number;
    public FinalGradeScore?: number;
    public Certificate?: boolean = null;
    public MinimumAttendanceMet?: boolean = true;
    public TrainingEventRosterDistinctionID?: number;
    public TrainingEventRosterDistinction: string = "";
    public NonAttendanceReasonID?: number;
    public NonAttendanceReason: string = "";
    public NonAttendanceCauseID?: number;
    public NonAttendanceCause: string = "";
    public Comments: string = "";
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);
    public Attendance?: TrainingEventParticipantAttendance[] = [];

    constructor()
    {
        this.Attendance = [];
    }
}