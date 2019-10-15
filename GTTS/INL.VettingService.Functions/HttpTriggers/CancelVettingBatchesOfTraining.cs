using System;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Security.Authentication;
using System.Net;
using System.Net.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using INL.UserService.Client;
using System.Linq;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class CancelVettingBatchesOfTraining
    {
        [FunctionName("CancelVettingBatchesOfTraining")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingEvents/{trainingEventID}")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();
                    
                    // Validate input
                    if (trainingEventID == 0)
                    {
                        throw new IndexOutOfRangeException();
                    }

                    //get queryname param
                    var isCancel = Convert.ToBoolean(request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key == "cancel").Value);

                    // cancel vetting batches
                    ICancelVettingBatch_Result result = null;
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();
 
                        // Instantiate VettingService
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);

                        // Call the VettingService
                        result = vettingService.CancelVettingBatchesForTrainingEvent(trainingEventID, myUserProfile.UserProfileItem.AppUserID, isCancel);
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

