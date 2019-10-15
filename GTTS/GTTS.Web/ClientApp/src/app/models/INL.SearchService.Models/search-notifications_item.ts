

import { ISearchNotifications_Item } from './isearch-notifications_item';

export class SearchNotifications_Item implements ISearchNotifications_Item {
  
	public NotificationID: number = 0;
	public NotificationSubject: string = "";
	public NotificationMessage: string = "";
	public NotificationContextType: string = "";
	public NotificationContextTypeID: number = 0;
	public ContextID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public AppUserID: number = 0;
	public Unread: boolean = false;
  
}


