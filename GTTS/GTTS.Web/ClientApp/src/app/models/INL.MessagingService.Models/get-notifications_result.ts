

import { Notification_Item } from './notification_item';
import { IGetNotifications_Result } from './iget-notifications_result';

export class GetNotifications_Result implements IGetNotifications_Result {
  
	public RecordCount: number = 0;
	public Collection?: Notification_Item[];
  
}


