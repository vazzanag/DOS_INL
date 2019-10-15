
namespace INL.TrainingService.Models
{
    public interface IParticipantCount_Item
    {
        long? TrainingEventGroupID { get; set; }
        string GroupName { get; set; }
        int? Students { get; set; }
        int? Instructors { get; set; }
    }
}
