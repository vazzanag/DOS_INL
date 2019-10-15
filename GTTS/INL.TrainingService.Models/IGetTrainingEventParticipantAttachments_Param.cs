
namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventParticipantAttachments_Param
    {
        long TrainingEventID { get; set; }
        long PersonID { get; set; }
        string ParticipantType { get; set; }
    }
}
