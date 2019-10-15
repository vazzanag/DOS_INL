



export interface INotificationsWithRecipients_Item {
  
	NotificationID: number;
	NotificationSubject: string;
	NotificationMessage: string;
	EmailMessage: string;
	NotificationContextType: string;
	NotificationContextTypeID?: number;
	ContextID?: number;
	NotificationModificationDate: Date;
	AppUserID: number;
	DateViewed?: Date;
	EmailSentDate?: Date;
	Subscribed: boolean;
	NotificationRecipientModificationDate: Date;

}

