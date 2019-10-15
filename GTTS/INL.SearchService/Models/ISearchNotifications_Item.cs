using System;

namespace INL.SearchService.Models
{
    public interface ISearchNotifications_Item
    {
        long NotificationID { get; set; }
        string NotificationSubject { get; set; }
        string NotificationMessage { get; set; }
        string NotificationContextType { get; set; }
        int NotificationContextTypeID { get; set; }
        long ContextID { get; set; }
        DateTime ModifiedDate { get; set; }
        int AppUserID { get; set; }
        bool Unread { get; set; }
    }
}
