import { NotificationRecipient } from './notification-recipient';

export class Notification
{
    public NotificationID: number = 0;
    public NotificationSubject: string = "";
    public NotificationMessage: string = "";
    public NotificationContextTypeID?: number;
    public NotificationContextType: string = "";
    public ContextID?: number;
    public ModifiedDate: Date = new Date(0);
    public NotificationMessageID: number = 0;
    public ModifiedByAppUserID: number = 0;
    public ModifiedByAppUser: string = "";
    public MessageTemplateName: string = "";
    public IncludeContextLink: boolean;
    public Unread: boolean;
    public ViewedDate?: Date;
    public EmailSentDate?: Date;
    public Subscribed: boolean;
    public NotificationRecipientModifiedDate: Date;
    public Recipients?: NotificationRecipient[];
}