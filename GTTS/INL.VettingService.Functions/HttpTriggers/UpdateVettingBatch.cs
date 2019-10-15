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

namespace INL.VettingService.Functions.HttpTriggers
{
    public class UpdateVettingBatch
    {

        [FunctionName("UpdateVettingBatch")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "batches/{vettingBatchID}")]HttpRequestMessage request, long vettingBatchID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
                    var updateVettingBatch_Param = await request.Content.ReadAsAsync<UpdateVettingBatch_Param>();

                    // Validate input
                    if (vettingBatchID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    if (vettingBatchID != updateVettingBatch_Param.VettingBatchID)
					{
						throw new ArgumentException();
					}


                    // Accept the vetting batch
                    IUpdateVettingBatch_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var messagingServiceClient = await helper.GetMessagingServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						updateVettingBatch_Param.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate VettingService
						var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);

						// Call the VettingService
						result = vettingService.UpdateVettingBatch(updateVettingBatch_Param, messagingServiceClient);
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

