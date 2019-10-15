using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public interface IDeleteTrainingEventParticipantXLSX_Param : IBaseParam
    {
        long ParticipantXLSXID { get; set; }
    }
}
