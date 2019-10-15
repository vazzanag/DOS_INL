using System;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using INL.UserService.Client;
using INL.MessagingService.Client;

namespace INL.VettingService.Functions.HttpTriggers
{
	public static class CreateVettingBatches
    {
        [FunctionName("CreateVettingBatches")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "batches")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveVettingBatchesParam = await request.Content.ReadAsAsyncCustom<SaveVettingBatches_Param>(new VettingServiceJsonConvertor().JsonConverters);

					// Save the vetting batches
					ISaveVettingBatches_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var messagingServiceClient = await helper.GetMessagingServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveVettingBatchesParam.Batches.ForEach(b =>
						{
							b.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
							b.PersonVettings.ForEach(p => p.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID);
						});

						// Instantiate VettingService
						var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);

						// Call the VettingService
						result = vettingService.SaveVettingBatches(saveVettingBatchesParam, messagingServiceClient);
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

