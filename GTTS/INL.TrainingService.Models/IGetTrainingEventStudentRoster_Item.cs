
namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventStudentRoster_Item
    {
        long TrainingEventID { get; set; }
        string TrainingEventName { get; set; }
        long? TrainingEventGroupID { get; set; }
        string TrainingEventGroupName { get; set; }
        byte[] FileContent { get; set; } 
    }
}
