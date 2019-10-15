using System;

namespace INL.MessagingService.Models
{
    public interface IUpdateNotificationDateViewed_Param
    {
        long NotificationID { get; set; }
        int AppUserID { get; set; }
        DateTime ViewedDate { get; set; }
    }
}
