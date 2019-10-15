
namespace INL.MessagingService.Models
{
    public class NotificationAppRoleContext_Item : INotificationAppRoleContext_Item
    {
        public long NotificationID { get; set; }
        public int NotificationMessageID { get; set; }
        public string NotificationContextType { get; set; }
        public int? NotificationContextTypeID { get; set; }
        public string AppRole { get; set; }
        public int AppRoleID { get; set; }
        public string Code { get; set; }
    }
}
