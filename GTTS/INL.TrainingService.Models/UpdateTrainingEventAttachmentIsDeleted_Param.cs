
namespace INL.TrainingService.Models
{
    public class UpdateTrainingEventAttachmentIsDeleted_Param : IUpdateTrainingEventAttachmentIsDeleted_Param
    {
        public long TrainingEventID { get; set; }
        public long AttachmentID { get; set; }
        public bool IsDeleted { get; set; }
    }
}
