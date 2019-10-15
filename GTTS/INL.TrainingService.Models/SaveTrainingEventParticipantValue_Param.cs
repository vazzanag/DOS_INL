
namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipantValue_Param : ISaveTrainingEventParticipantValue_Param
    {
        public string ColumnName { get; set; }
        public string Value { get; set; }
        public string ParticipantType { get; set; }
        public long PersonID { get; set; }
        public long TrainingEventID { get; set; } 
    }
}
