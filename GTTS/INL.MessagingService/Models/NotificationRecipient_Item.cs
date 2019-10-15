using System;

namespace INL.MessagingService.Models
{
    public class NotificationRecipient_Item : INotificationRecipient_Item
    {
        public long NotificationID { get; set; }
        public int AppUserID { get; set; }
        public DateTime? ViewedDate { get; set; }
        public DateTime? EmailSentDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public bool Unread { get; set; }
        public string AppUser { get; set; }
    }
}
