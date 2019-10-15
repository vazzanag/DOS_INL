
namespace INL.TrainingService.Models
{
    public class GetTrainingEventParticipantAttachment_Param : IGetTrainingEventParticipantAttachment_Param
    {
        public long TrainingEventParticipantAttachmentID { get; set; }
        public string ParticipantType { get; set; }
        public int? FileVersion { get; set; }
    }
}
