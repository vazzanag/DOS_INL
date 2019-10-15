using System;

namespace INL.MessagingService.Models
{
    public class UpdateNotificationDateViewed_Param : IUpdateNotificationDateViewed_Param
    {
        public long NotificationID { get; set; }
        public int AppUserID { get; set; }
        public DateTime ViewedDate { get; set; }
    }
}
