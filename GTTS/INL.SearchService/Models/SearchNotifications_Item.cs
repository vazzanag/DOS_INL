using System;

namespace INL.SearchService.Models
{
    public class SearchNotifications_Item : ISearchNotifications_Item
    {
        public long NotificationID { get; set; }
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
