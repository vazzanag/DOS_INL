
namespace INL.TrainingService.Models
{
    public interface IUpdateTrainingEventAttachmentIsDeleted_Param
    {
        long TrainingEventID { get; set; }
        long AttachmentID { get; set; }
        bool IsDeleted { get; set; }
    }
}
