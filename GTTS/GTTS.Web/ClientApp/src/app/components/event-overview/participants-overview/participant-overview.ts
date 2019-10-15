export class ParticipantOverview
{
    /* Participants */
    public StudentCount: number = 0;
    public InstructorCount: number = 0;
    public AlternateCount: number = 0;
    public ParticipantCount: number = 0;
    public PlannedParticipantCount: number = 0;

    /* Vetting */
    public LeahyCount: number = 0;
    public CourtesyCount: number = 0;
    public NACount: number = 0;

    public ApprovedCount: number = 0;
    public ApprovedPercentage: number = 0;
    public InProgressCount: number = 0;
    public InProgressPercentage: number = 0;
    public SuspendedCount: number = 0;
    public SuspendedPercentage: number = 0;
    public CanceledCount: number = 0;
    public CanceledPercentage: number = 0;
    public RejectedCount: number = 0;
    public RejectedPercentage: number = 0;

    /*  Vetting Chart */
    public ApprovedDashArray: string = '';
    public ApprovedDashOffset: number = 0;
    public ApprovedSeperatorDashOffset: number = 0;

    public InProgressDashArray: string = '';
    public InProgressDashOffset: number = 0;
    public InProgressSeperatorDashOffset: number = 0;

    public SuspendedDashArray: string = '';
    public SuspendedDashOffset: number = 0;
    public SuspendedSeperatorDashOffset: number = 0;

    public CanceledDashArray: string = '';
    public CanceledDashOffset: number = 0;
    public CanceledSeperatorDashOffset: number = 0;

    public RejectedDashArray: string = '';
    public RejectedDashOffset: number = 0;
    public RejectedSeperatorDashOffset: number = 0;
    
    /* Performance */
    public AverageFinalGradePercentage: number = 0;
    public CompleteCertificatePercentage: number = 0;
    public StudentsInRosterCount: number = 0;
    public KeyParticipantsCount: number = 0;
    public UnsatisfactoryCount: number = 0;
    public HasUploadedRoster: boolean = false;
}