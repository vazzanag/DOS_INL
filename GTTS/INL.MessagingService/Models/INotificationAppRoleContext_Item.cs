
namespace INL.MessagingService.Models
{
    public interface INotificationAppRoleContext_Item
    {
        long NotificationID { get; set; }
        int NotificationMessageID { get; set; }
        string NotificationContextType { get; set; }
        int? NotificationContextTypeID { get; set; }
        string AppRole { get; set; }
        int AppRoleID { get; set; }
        string Code { get; set; }
    }
}
