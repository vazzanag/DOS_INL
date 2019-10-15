export class NotificationRecipient
{
    public NotificationID: number = 0;
    public AppUserID: number = 0;
    public DateViewed?: Date;
    public EmailSentDate?: Date;
    public Subscribed: boolean = false;
    public ModifiedDate: Date = new Date(0);
    public AppUser: string = "";
}