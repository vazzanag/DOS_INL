

import { INotificationPersonsVettingVettingTypeCreated_Item } from './inotification-persons-vetting-vetting-type-created_item';

export class NotificationPersonsVettingVettingTypeCreated_Item implements INotificationPersonsVettingVettingTypeCreated_Item {
  
	public VettingBatchID: number = 0;
	public GTTSTrackingNumber: string = "";
	public VettingTypeID: number = 0;
	public VettingType: string = "";
	public Name: string = "";
	public OrganizerAppUserID: number = 0;
	public EventStartDate: Date = new Date(0);
	public EventEndDate: Date = new Date(0);
	public ParticipantsCount: number = 0;
	public CourtesyCheckTimeFrame: number = 0;
	public CourtesyVetters?: any[];
	public RedirectorURL: string = "";
	public EventStart: string = "";
	public EventEnd: string = "";
  
}


