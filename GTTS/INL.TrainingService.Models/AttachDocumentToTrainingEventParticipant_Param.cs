
namespace INL.TrainingService.Models
{
    public class AttachDocumentToTrainingEventParticipant_Param : IAttachDocumentToTrainingEventParticipant_Param
    {
        public long TrainingEventID { get; set; }
        public long PersonID { get; set; }
        public string ParticipantType { get; set; }
        public string Description { get; set; }
        public int TrainingEventParticipantAttachmentTypeID { get; set; }
        public string FileName { get; set; }
        public int FileVersion { get; set; }
        public int ModifiedByAppUserID { get; set; }
    }
}
