using System;
using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public interface INotification_Item
    {
        long NotificationID { get; set; }
        string NotificationSubject { get; set; }
        string NotificationMessage { get; set; }
        string EmailMessage { get; set; }
        bool Unread { get; set; }
        int NotificationContextTypeID { get; set; }
        string NotificationContextType { get; set; }
        long ContextID { get; set; }
        DateTime ModifiedDate { get; set; }
        int NotificationMessageID { get; set; }
        int ModifiedByAppUserID { get; set; }
        string ModifiedByAppUser { get; set; }
        string MessageTemplateName { get; set; }
        bool IncludeContextLink { get; set; }
        int AppUserID { get; set; }
        DateTime? ViewedDate { get; set; }
        DateTime? EmailSentDate { get; set; }
        DateTime NotificationRecipientModifiedDate { get; set; }

        List<NotificationRecipient_Item> Recipients { get; set; }
    }
}
