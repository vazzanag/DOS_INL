
namespace INL.TrainingService.Models
{
    public class GetTrainingEventStudentRoster_Item : IGetTrainingEventStudentRoster_Item
    {
        public long TrainingEventID { get; set; }
        public string TrainingEventName { get; set; }
        public long? TrainingEventGroupID { get; set; }
        public string TrainingEventGroupName { get; set; }
        public byte[] FileContent { get; set; }
    }
}
