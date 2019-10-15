
namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventParticipantAttachment_Param
    {
        long TrainingEventParticipantAttachmentID { get; set; }
        string ParticipantType { get; set; }
        int? FileVersion { get; set; }
    }
}
