
namespace INL.MessagingService.Data
{
    public interface INotificationRosterUploadedViewEntity
    {
        long TrainingEventID { get; set; }
        string Name { get; set; }
        int OrganizerAppUserID { get; set; }
        string UploadedBy { get; set; }
        string KeyParticipantsJSON { get; set; }
        string UnsatisfactoryParticipantsJSON { get; set; }
        string StakeholdersJSON { get; set; }
    }
}
