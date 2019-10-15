


import { NotificationRecipient_Item } from './notification-recipient_item';

export interface INotification_Item {
  
	NotificationID: number;
	NotificationSubject: string;
	NotificationMessage: string;
	EmailMessage: string;
	Unread: boolean;
	NotificationContextTypeID: number;
	NotificationContextType: string;
	ContextID: number;
	ModifiedDate: Date;
	NotificationMessageID: number;
	ModifiedByAppUserID: number;
	ModifiedByAppUser: string;
	MessageTemplateName: string;
	IncludeContextLink: boolean;
	AppUserID: number;
	ViewedDate?: Date;
	EmailSentDate?: Date;
	NotificationRecipientModifiedDate: Date;
	Recipients?: NotificationRecipient_Item[];

}

