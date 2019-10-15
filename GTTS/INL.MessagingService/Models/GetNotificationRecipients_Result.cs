using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public class GetNotificationRecipients_Result : IGetNotificationRecipients_Result
    {
        public List<NotificationRecipient_Item> Collection { get; set; }
    }
}
