
namespace INL.TrainingService.Models
{
    public interface IUpdateTrainingEventParticipantAttachmentIsDeleted_Param
    {
        long TrainingEventID { get; set; }
        long AttachmentID { get; set; }
        long PersonID { get; set; }
        string ParticipantType { get; set; }
        bool IsDeleted { get; set; }
    }
}
