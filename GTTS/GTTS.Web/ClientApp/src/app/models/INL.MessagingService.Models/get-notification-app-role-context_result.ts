

import { NotificationAppRoleContext_Item } from './notification-app-role-context_item';
import { IGetNotificationAppRoleContext_Result } from './iget-notification-app-role-context_result';

export class GetNotificationAppRoleContext_Result implements IGetNotificationAppRoleContext_Result {
  
	public NotificationID: number = 0;
	public ContextID: number = 0;
	public NotificationContextType: string = "";
	public Item?: NotificationAppRoleContext_Item;
  
}


