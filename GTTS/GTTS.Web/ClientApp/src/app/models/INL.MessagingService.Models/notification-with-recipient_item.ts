

import { INotificationWithRecipient_Item } from './inotification-with-recipient_item';

export class NotificationWithRecipient_Item implements INotificationWithRecipient_Item {
  
	public NotificationID: number = 0;
	public NotificationSubject: string = "";
	public NotificationMessage: string = "";
	public EmailMessage: string = "";
	public NotificationContextType: string = "";
	public NotificationContextTypeID?: number;
	public ContextID?: number;
	public NotificationModificationDate: Date = new Date(0);
	public AppUserID: number = 0;
	public DateViewed?: Date;
	public EmailSentDate?: Date;
	public Subscribed: boolean = false;
	public NotificationRecipientModificationDate: Date = new Date(0);
  
}


