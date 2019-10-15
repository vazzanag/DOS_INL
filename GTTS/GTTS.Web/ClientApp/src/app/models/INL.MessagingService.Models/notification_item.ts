

import { NotificationRecipient_Item } from './notification-recipient_item';
import { INotification_Item } from './inotification_item';

export class Notification_Item implements INotification_Item {
  
	public NotificationID: number = 0;
	public NotificationSubject: string = "";
	public NotificationMessage: string = "";
	public EmailMessage: string = "";
	public Unread: boolean = false;
	public NotificationContextTypeID: number = 0;
	public NotificationContextType: string = "";
	public ContextID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public NotificationMessageID: number = 0;
	public ModifiedByAppUserID: number = 0;
	public ModifiedByAppUser: string = "";
	public MessageTemplateName: string = "";
	public IncludeContextLink: boolean = false;
	public AppUserID: number = 0;
	public ViewedDate?: Date;
	public EmailSentDate?: Date;
	public NotificationRecipientModifiedDate: Date = new Date(0);
	public Recipients?: NotificationRecipient_Item[];
  
}


