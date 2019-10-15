
namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipantValue_Param
    {
        string ColumnName { get; set; }
        string Value { get; set; }
        string ParticipantType { get; set; }
        long PersonID { get; set; }
        long TrainingEventID { get; set; }
    }
}
