using System.Collections.Generic;

namespace INL.MessagingService.Client.Models
{
    interface INotificationRosterUploaded_Item
    {
        long TrainingEventID { get; set; }
        string Name { get; set; }
        int OrganizerAppUserID { get; set; }
        string UploadedBy { get; set; }
        string EventOverviewURL { get; set; }
        List<NotificationRecipientNamesObj> KeyParticipants { get; set; }
        List<NotificationRecipientNamesObj> UnsatisfactoryParticipants { get; set; }
        List<AppUserIDObj> Stakeholders { get; set; }
    }
}
