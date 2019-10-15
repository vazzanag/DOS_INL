
export class TrainingEventParticipantSearch
{
    public PersonID: number;
    public Selected: boolean = false;
    public ParticipantType: string = "";
    public FirstMiddleNames: string = "";
    public LastNames: string = "";
    public Gender: string = "";
    public UnitID: number = 0;
    public UnitName: string = "";
    public UnitNameEnglish: string = "";
    public AgencyName: string = "";
    public AgencyNameEnglish: string = "";
    public JobTitle: string = "";
    public RankID?: number;
    public RankName: string = "";
    public VettingStatusID?: number;
    public VettingStatus: string = "";
    public VettingType: string = "";
    public VettingStatusDate: Date = new Date(0);
    public Distinction: string = "";
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);
}