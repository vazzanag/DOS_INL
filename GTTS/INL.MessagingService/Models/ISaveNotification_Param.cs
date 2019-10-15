
namespace INL.MessagingService.Models
{
    public interface ISaveNotification_Param
    {
        int ContextTypeID { get; set; }
        long ContextID { get; set; }
        int? NotificationMessageID { get; set; }
        string NotificationMessage { get; set; }
        string NotificationSubject { get; set; }
    }
}
