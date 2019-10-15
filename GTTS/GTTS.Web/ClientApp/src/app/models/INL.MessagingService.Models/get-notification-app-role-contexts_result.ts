

import { NotificationAppRoleContext_Item } from './notification-app-role-context_item';
import { IGetNotificationAppRoleContexts_Result } from './iget-notification-app-role-contexts_result';

export class GetNotificationAppRoleContexts_Result implements IGetNotificationAppRoleContexts_Result {
  
	public NotificationID: number = 0;
	public ContextID: number = 0;
	public NotificationContextType: string = "";
	public Collection?: NotificationAppRoleContext_Item[];
  
}


