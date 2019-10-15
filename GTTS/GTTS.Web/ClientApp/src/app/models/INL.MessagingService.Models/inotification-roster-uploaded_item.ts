


import { NotificationRecipientNamesObj } from './notification-recipient-names-obj';
import { AppUserIDObj } from './app-user-idobj';

export interface INotificationRosterUploaded_Item {
  
	TrainingEventID: number;
	Name: string;
	UploadedBy: string;
	KeyParticipants?: NotificationRecipientNamesObj[];
	UnsatisfactoryParticipants?: NotificationRecipientNamesObj[];
	Stakeholders?: AppUserIDObj[];

}

