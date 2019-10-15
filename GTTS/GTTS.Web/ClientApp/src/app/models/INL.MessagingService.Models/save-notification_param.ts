

import { ISaveNotification_Param } from './isave-notification_param';

export class SaveNotification_Param implements ISaveNotification_Param {
  
	public ContextTypeID: number = 0;
	public ContextID: number = 0;
	public NotificationMessageID?: number;
	public NotificationMessage: string = "";
	public NotificationSubject: string = "";
  
}


