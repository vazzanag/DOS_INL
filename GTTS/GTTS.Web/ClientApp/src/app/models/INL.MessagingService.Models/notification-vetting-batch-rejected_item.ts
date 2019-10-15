


export class NotificationVettingBatchRejected_Item  {
  
	public VettingBatchID: number = 0;
	public VettingBatchTypeID: number = 0;
	public VettingBatchType: string = "";
	public Name: string = "";
	public OrganizerAppUserID: number = 0;
	public AppUserIDSubmitted: number = 0;
	public BatchRejectionReason: string = "";
	public EventStartDate: Date = new Date(0);
	public EventEndDate: Date = new Date(0);
	public ParticipantsCount: number = 0;
	public BatchViewURL: string = "";
	public Stakeholders?: any[];
	public EventStart: string = "";
	public EventEnd: string = "";
  
}


