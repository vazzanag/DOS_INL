using INL.Functions;
using INL.MessagingService.Data;
using INL.MessagingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace INL.MessagingService.Functions.HttpTriggers.Notifications.Vetting
{
    public static class VettingBatchAccepted
	{
        [FunctionName("VettingBatchAccepted")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "notifications/vettingbatchaccepted")]HttpRequestMessage request,
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

                    var vettingBatchAcceptedParam = await request.Content.ReadAsAsyncCustom<SaveNotification_Param>(new MessagingServiceJsonConverter().JsonConverters);

                    long result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var vettingServiceClient = await helper.GetVettingServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						var messagingRepository = new MessagingRepository(sqlConnection);
						var messagingService = new MessagingService(messagingRepository);

						// Get the profile to send AppUserID to service
						var myUserProfile = await userService.GetMyProfile();

						result = messagingService.CreateVettingBatchAcceptedNotification(vettingBatchAcceptedParam, helper.GTTSWebsiteURL,
							myUserProfile.UserProfileItem.AppUserID, myUserProfile.UserProfileItem.PostID, myUserProfile.UserProfileItem.FullName, myUserProfile.UserProfileItem.EmailAddress, vettingServiceClient);
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
