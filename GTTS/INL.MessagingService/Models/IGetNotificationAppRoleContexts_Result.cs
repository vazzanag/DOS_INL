using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public interface IGetNotificationAppRoleContexts_Result
    {
        long NotificationID { get; set; }
        long ContextID { get; set; }
        string NotificationContextType { get; set; }
        List<NotificationAppRoleContext_Item> Collection { get; set; }
    }
}
