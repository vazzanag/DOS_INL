using System.Threading.Tasks;
using INL.TrainingService.Models;

namespace INL.TrainingService.Client
{
    public interface ITrainingServiceClient
    {
        Task<IGetPersonsTrainingEvents_Result> GetPersonsTrainingEventsAsync(long personID, string trainingEventStatus);
        Task<IGetTrainingEventParticipants_Result> GetTrainingEventRemovedParticipants(long trainingEventID);
        Task<IGetTrainingEventLocations_Result> GetTrainingEventLocations(long trainingEventID);
        Task<IGetTrainingEventParticipants_Result> GetTrainingEventParticipants(long trainingEventID);
    }
}
