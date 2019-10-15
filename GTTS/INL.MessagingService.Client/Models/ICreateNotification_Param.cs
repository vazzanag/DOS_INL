
namespace INL.MessagingService.Client.Models
{
    public interface ICreateNotification_Param
    {
        int ContextTypeID { get; set; }
        long ContextID { get; set; }
        int? NotificationMessageID { get; set; }
        int ModifiedByAppUserID { get; set; }
        string NotificationMessage { get; set; }
        string NotificationSubject { get; set; }
    }
}
