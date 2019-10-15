using System;

namespace INL.MessagingService.Models
{
    public interface INotificationRecipient_Item
    {
        long NotificationID { get; set; }
        int AppUserID { get; set; }
        DateTime? ViewedDate { get; set; }
        DateTime? EmailSentDate { get; set; }
        DateTime ModifiedDate { get; set; }
        bool Unread { get; set; }
        string AppUser { get; set; }
    }
}
