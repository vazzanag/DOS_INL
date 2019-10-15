

import { INotificationRecipient_Item } from './inotification-recipient_item';

export class NotificationRecipient_Item implements INotificationRecipient_Item {
  
	public NotificationID: number = 0;
	public AppUserID: number = 0;
	public ViewedDate?: Date;
	public EmailSentDate?: Date;
	public ModifiedDate: Date = new Date(0);
	public Unread: boolean = false;
	public AppUser: string = "";
  
}


