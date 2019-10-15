

import { NotificationRejectedParticipant_Item } from './notification-rejected-participant_item';

export class NotificationVettingBatchResultsNotifiedWithRejections_Item  {
  
	public VettingBatchID: number = 0;
	public VettingBatchTypeID: number = 0;
	public VettingBatchType: string = "";
	public GTTSTrackingNumber: string = "";
	public Name: string = "";
	public OrganizerAppUserID: number = 0;
	public AppUserIDSubmitted: number = 0;
	public EventStartDate: Date = new Date(0);
	public EventEndDate: Date = new Date(0);
	public Stakeholders?: any[];
	public RejectedParticipants?: NotificationRejectedParticipant_Item[];
	public BatchViewURL: string = "";
	public PocFullName: string = "";
	public PocEmailAddress: string = "";
	public EventStart: string = "";
	public EventEnd: string = "";
  
}


