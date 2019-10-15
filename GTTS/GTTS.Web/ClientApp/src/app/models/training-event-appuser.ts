export class TrainingEventAppUser
{
    public AppUserID: number = 0;
    public ADOID: string;
    public First: string;
    public Middle: string;
    public Last: string;
    public FullName: string;
    public PositionTitle: string;
    public EmailAddress: string;
    public PhoneNumber: string;
    public PicturePath: string;
    public PayGradeID?: number;
    public ModifiedByAppUserID?: number;
    public ModifiedDate: Date;
}