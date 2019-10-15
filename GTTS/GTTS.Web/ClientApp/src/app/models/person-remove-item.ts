

export class PersonRemoveItem {
    public PersonID?: number;
    public FirstMiddleNames: string = "";
    public LastNames: string = "";
    public IsParticipant: boolean = true;
    public RemovedFromEvent: boolean = false;
    public ReasonRemoved: string = "";
    public RemovalReasonID?: number;
    public ReasonSpecific: string = "";
    public RemovalCauseID?: number;
    public DateCanceled?: Date;
    public DOB?: Date;
}
