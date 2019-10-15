
namespace INL.MessagingService.Client.Models
{
    public class CreateNotification_Param : ICreateNotification_Param
    {
        public int ContextTypeID { get; set; }
        public long ContextID { get; set; }
        public int? NotificationMessageID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string NotificationMessage { get; set; }
        public string NotificationSubject { get; set; }
    }
}
