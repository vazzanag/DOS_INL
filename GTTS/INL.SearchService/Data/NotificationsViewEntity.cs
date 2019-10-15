using System;

namespace INL.SearchService.Data
{
    public class NotificationsViewEntity : INotificationsViewEntity
    {
        public int Rank { get; set; }
        public long NotificationID { get; set; }
        public string ContextName { get; set; }
        public string GTTSTrackingNumber { get; set; }
        public string LeahyTrackingNumber { get; set; }
        public string INKTrackingNumber { get; set; }
        public string NotificationSubject { get; set; }
        public string NotificationMessage { get; set; }
        public string NotificationContextType { get; set; }
        public int NotificationContextTypeID { get; set; }
        public long ContextID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int AppUserID { get; set; }
        public bool Unread { get; set; }
    }
}
