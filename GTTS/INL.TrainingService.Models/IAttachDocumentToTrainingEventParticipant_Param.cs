
namespace INL.TrainingService.Models
{
    public interface IAttachDocumentToTrainingEventParticipant_Param
    {
        long TrainingEventID { get; set; }
        long PersonID { get; set; }
        string ParticipantType { get; set; }
        string Description { get; set; }
        int TrainingEventParticipantAttachmentTypeID { get; set; }
        string FileName { get; set; }
        int FileVersion { get; set; }
        int ModifiedByAppUserID { get; set; }
    }
}
