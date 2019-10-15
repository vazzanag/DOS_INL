using System;
using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public class Notification_Item : INotification_Item
    {
        public long NotificationID { get; set; }
        public string NotificationSubject { get; set; }
        public string NotificationMessage { get; set; }
        public string EmailMessage { get; set; }
        public bool Unread { get; set; }
        public int NotificationContextTypeID { get; set; }
        public string NotificationContextType { get; set; }
        public long ContextID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int NotificationMessageID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string ModifiedByAppUser { get; set; }
        public string MessageTemplateName { get; set; }
        public bool IncludeContextLink { get; set; }
        public int AppUserID { get; set; }
        public DateTime? ViewedDate { get; set; }
        public DateTime? EmailSentDate { get; set; }
        public DateTime NotificationRecipientModifiedDate { get; set; }

        public List<NotificationRecipient_Item> Recipients { get; set; }
    }
}
