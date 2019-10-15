
namespace INL.TrainingService.Models
{
    public class ParticipantCount_Item : IParticipantCount_Item
    {
        public long? TrainingEventGroupID { get; set; }
        public string GroupName { get; set; }
        public int? Students { get; set; }
        public int? Instructors { get; set; }
    }
}
