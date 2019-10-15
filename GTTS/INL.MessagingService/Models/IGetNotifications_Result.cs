using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public interface IGetNotifications_Result
    {
        int RecordCount { get; set; }
        List<Notification_Item> Collection { get; set; }
    }
}
