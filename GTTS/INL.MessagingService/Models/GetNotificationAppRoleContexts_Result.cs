using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    public class GetNotificationAppRoleContexts_Result : IGetNotificationAppRoleContexts_Result
    {
        public long NotificationID { get; set; }
        public long ContextID { get; set; }
        public string NotificationContextType { get; set; }
        public List<NotificationAppRoleContext_Item> Collection { get; set; }
    }
}
