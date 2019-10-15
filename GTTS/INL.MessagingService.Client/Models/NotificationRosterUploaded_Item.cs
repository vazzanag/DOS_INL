using System.Collections.Generic;

namespace INL.MessagingService.Client.Models
{
    public class NotificationRosterUploaded_Item : INotificationRosterUploaded_Item
    {
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public int OrganizerAppUserID { get; set; }
        public string UploadedBy { get; set; }
        public string EventOverviewURL { get; set; }
        public List<NotificationRecipientNamesObj> KeyParticipants { get; set; }
        public List<NotificationRecipientNamesObj> UnsatisfactoryParticipants { get; set; }
        public List<AppUserIDObj> Stakeholders { get; set; }
    }
}
