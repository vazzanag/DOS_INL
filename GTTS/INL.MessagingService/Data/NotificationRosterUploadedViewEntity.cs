
namespace INL.MessagingService.Data
{
    public class NotificationRosterUploadedViewEntity : INotificationRosterUploadedViewEntity
    {
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public int OrganizerAppUserID { get; set; }
        public string UploadedBy { get; set; }
        public string KeyParticipantsJSON { get; set; }
        public string UnsatisfactoryParticipantsJSON { get; set; }
        public string StakeholdersJSON { get; set; }
    }
}
