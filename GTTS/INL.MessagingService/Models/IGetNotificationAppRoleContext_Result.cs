
namespace INL.MessagingService.Models
{
    public interface IGetNotificationAppRoleContext_Result
    {
        long NotificationID { get; set; }
        long ContextID { get; set; }
        string NotificationContextType { get; set; }
        NotificationAppRoleContext_Item Item { get; set; }
    }
}
