using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.VettingService.Models;
using INL.VettingService.Data;
using INL.TrainingService.Client;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class SaveCourtesyBatch
    {
        [FunctionName("SaveCourtesyBatch")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "courtesy/{VettingBatchID}")]HttpRequestMessage request, long vettingBatchID, ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    // Read input
                    var param = await request.Content.ReadAsAsyncCustom<SaveCourtesyBatch_Param>(new VettingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (vettingBatchID == 0)
                    {
                        throw new IndexOutOfRangeException();
                    }

                    // Ensure the id on the URL matches the id in the payload
                    if (vettingBatchID != param.VettingBatchID)
                    {
                        throw new ArgumentException();
                    }
					
					// Save the courtesy batch
					IGetCourtesyBatch_Result result = null;					
					using (var trainingServiceclient = await helper.GetTrainingServiceClientAsync())
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var messagingServiceClient = await helper.GetMessagingServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						param.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
						if (param.isSubmit)
						{
							param.ResultsSubmittedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
							param.ResultsSubmittedDate = DateTime.Today;
						}

						var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);

						result = vettingService.SaveCourtesyBatch(param, trainingServiceclient, messagingServiceClient);
					}

                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK, result);
                }
                catch (Exception ex)
                {
                    return helper.CreateErrorResponse(ex);
                }
            }
        }
    }
}