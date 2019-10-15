using System.Threading.Tasks;
using System.Collections.Generic;
using INL.VettingService.Models;

namespace INL.VettingService.Client
{
    public interface IVettingServiceClient
    {
        Task<GetPostVettingConfiguration_Result> GetPostVettingConfigurationAsync(int PostID);
        Task<IGetVettingBatch_Result> GetVettingBatch(long vettingBatchID);
        Task<IGetPersonsVettings_Result> GetParticipantVettingsAsync(long vettingBpersonIDatchID);
        Task<ICancelVettingBatch_Result> CancelVettingBatchesforEvent(long trainingEventID, bool isCancel);
        Task<IGetPersonVettingStatuses_Result> GetPersonVettingStatus(long personID);
        Task<IRemoveParticipantsFromVetting_Result> RemoveParticipantFromVetting(IRemoveParticipantFromVetting_Param param);
    }
}
