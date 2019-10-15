
namespace INL.TrainingService.Models
{
    public class UpdateTrainingEventParticipantAttachmentIsDeleted_Param : IUpdateTrainingEventParticipantAttachmentIsDeleted_Param
    {
        public long TrainingEventID { get; set; }
        public long AttachmentID { get; set; }
        public long PersonID { get; set; }
        public string ParticipantType { get; set; }
        public bool IsDeleted { get; set; }
    }
}
