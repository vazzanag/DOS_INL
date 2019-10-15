
namespace INL.MessagingService.Models
{
    public class GetNotificationAppRoleContext_Result : IGetNotificationAppRoleContext_Result
    {
        public long NotificationID { get; set; }
        public long ContextID { get; set; }
        public string NotificationContextType { get; set; }
        public NotificationAppRoleContext_Item Item { get; set; }
    }
}
