using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public interface IGetNotificationRecipients_Result
    {
        List<NotificationRecipient_Item> Collection { get; set; }
    }
}
