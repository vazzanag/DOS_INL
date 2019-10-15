using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public interface IDeleteTrainingEventParticipant_Param : IBaseParam
    {
        long TrainingEventID { get; set; }
        long ParticipantID { get; set; }
        string ParticipantType { get; set; }
    }
}
