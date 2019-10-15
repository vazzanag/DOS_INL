using System;

namespace INL.SearchService.Data
{
    public interface INotificationsViewEntity
    {
        int Rank { get; set; }
        long NotificationID { get; set; }
        string ContextName { get; set; }
        string GTTSTrackingNumber { get; set; }
        string LeahyTrackingNumber { get; set; }
        string INKTrackingNumber { get; set; }
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
