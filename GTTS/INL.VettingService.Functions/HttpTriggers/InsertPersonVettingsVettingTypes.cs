using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.VettingService.Models;
using INL.VettingService.Data;
using INL.MessagingService.Client;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class InsertPersonVettingsVettingTypes
    {
        [FunctionName("InsertPersonVettingsVettingTypes")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "batches/{vettingBatchID}/personvettings")]HttpRequestMessage request,
            long vettingBatchID,
            ILogger log,
            ExecutionContext context)
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
                    var associateParam = await request.Content.ReadAsAsyncCustom<InsertPersonVettingVettingType_Param>(new VettingServiceJsonConvertor().JsonConverters);


                    // Validate input
                    if (vettingBatchID == 0)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.NotFound, "");
                    }

                    // Save the person vetting vetting type result
                    InsertPersonVettingVettingType_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var messagingServiceClient = await helper.GetMessagingServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();

						associateParam.ModifiedAppUserID = myUserProfile.UserProfileItem.AppUserID;
						associateParam.PostID = myUserProfile.UserProfileItem.PostID.GetValueOrDefault();
						var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);
						result = vettingService.InsertPersonVettingVettingType(associateParam, messagingServiceClient);
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