using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public class GetNotifications_Result : IGetNotifications_Result
    {
        public int RecordCount { get; set; }
        public List<Notification_Item> Collection { get; set; }
    }
}
