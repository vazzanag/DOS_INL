

import { INotificationAppRoleContext_Item } from './inotification-app-role-context_item';

export class NotificationAppRoleContext_Item implements INotificationAppRoleContext_Item {
  
	public NotificationID: number = 0;
	public NotificationMessageID: number = 0;
	public NotificationContextType: string = "";
	public NotificationContextTypeID?: number;
	public AppRole: string = "";
	public AppRoleID: number = 0;
	public Code: string = "";
  
}


