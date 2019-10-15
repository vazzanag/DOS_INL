using System.Collections.Generic;

namespace INL.MessagingService.Models
{
    interface INotificationRosterUploaded_Item
    {
        long TrainingEventID { get; set; }
        string Name { get; set; }
        int OrganizerAppUserID { get; set; }
        string UploadedBy { get; set; }
        string EventOverviewURL { get; set; }
        List<dynamic> KeyParticipants { get; set; }
        List<dynamic> UnsatisfactoryParticipants { get; set; }
        List<dynamic> Stakeholders { get; set; }
    }
}
