using INL.VettingService.Client;
using INL.VettingService.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace INL.UnitTests
{
    public class MockedVettingServiceClient : IVettingServiceClient
    {
        public Task<GetPostVettingConfiguration_Result> GetPostVettingConfigurationAsync(int postID)
        {
            var result = new GetPostVettingConfiguration_Result()
            {
                PostID = 1,
                MaxBatchSize = 5,
                LeahyBatchLeadTime = 60,
                CourtesyBatchLeadTime = 5
            };

            return Task.FromResult<GetPostVettingConfiguration_Result>(result);
        }

        public Task<IGetVettingBatch_Result> GetVettingBatch(long vettingBatchID)
        {
            var result = new GetVettingBatch_Result()
            {
                Batch = new VettingBatch_Item()
                {
                    VettingBatchID = 1,
                    VettingBatchName = "Test Batch",
                    VettingBatchNumber = 1
                }
            };
            return Task.FromResult<IGetVettingBatch_Result>(result);
        }

        public Task<IGetPersonsVettings_Result> GetParticipantVettingsAsync(long personID)
        {
            var result = new GetPersonsVettings_Result()
            {
                VettingCollection = new List<GetPersonsVetting_Item>()
                {
                    new GetPersonsVetting_Item()
                    {
                        PersonsVettingID = 1,
                    },
                    new GetPersonsVetting_Item()
                    {
                        PersonsVettingID = 2,
                    },
                }
            };
            return Task.FromResult<IGetPersonsVettings_Result>(result);

        }
        public Task<ICancelVettingBatch_Result> CancelVettingBatchesforEvent(long trainingEventID, bool isCancel)
        {
            var result = new CancelVettingBatch_Result()
            {
                VettingBatchID = new List<long>()
                {
                    1,2,3
                }
            };
            return Task.FromResult<ICancelVettingBatch_Result>(result);
        }
        public Task<IGetPersonVettingStatuses_Result> GetPersonVettingStatus(long personID)
        {
            throw new NotImplementedException();
        }
        public Task<IRemoveParticipantsFromVetting_Result> RemoveParticipantFromVetting(IRemoveParticipantFromVetting_Param param)
        {
            var result = new RemoveParticipantsFromVetting_Result()
            {
                PersonsIDs = param.PersonIDs.ToList()
            };
            return Task.FromResult<IRemoveParticipantsFromVetting_Result>(result);
        }
    }
}
