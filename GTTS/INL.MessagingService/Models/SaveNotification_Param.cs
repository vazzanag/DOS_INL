
namespace INL.MessagingService.Models
{
    public class SaveNotification_Param : ISaveNotification_Param
    {
        public int ContextTypeID { get; set; }
        public long ContextID { get; set; }
        public int? NotificationMessageID { get; set; }
        public string NotificationMessage { get; set; }
        public string NotificationSubject { get; set; }
    }
}
