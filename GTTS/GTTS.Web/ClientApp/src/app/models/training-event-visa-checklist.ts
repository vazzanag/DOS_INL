
export class TrainingEventVisaCheckList {
    public PersonID: number = 0;
    public TrainingEventID?: number;
    public TrainingEventVisaCheckListID?: number;
    public FirstMiddleNames: string = "";
    public LastNames: string = "";
    public AgencyName: string = "";
    public VettingStatus: string = "";
    public HasHostNationCorrespondence?: boolean;
    public HasUSGCorrespondence?: boolean;
    public IsApplicationComplete?: boolean;
    public ApplicationSubmittedDate?: Date;
    public HasPassportAndPhotos?: boolean;
    public VisaStatus: string = "";
    public TrackingNumber: string = "";
    public Comments: string = "";
}

