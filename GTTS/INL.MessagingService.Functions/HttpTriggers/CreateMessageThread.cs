using INL.Functions;
using INL.UserService.Client;
using INL.MessagingService.Data;
using INL.MessagingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;

namespace INL.MessagingService.Functions.HttpTriggers
{
    public static class CreateMessageThread
    {
        [FunctionName("CreateMessageThread")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "messagethreads")]HttpRequestMessage request,
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

					// Get parameter
					var saveMessageThreadParam = await request.Content.ReadAsAsyncCustom<SaveMessageThread_Param>(new MessagingServiceJsonConverter().JsonConverters);
					
					// Save the Message Thread
					MessageThread_Item result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveMessageThreadParam.Item.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate MessagingService
						var messagingRepository = new MessagingRepository(sqlConnection);
                        var messagingService = new MessagingService(messagingRepository);

						// Call the MessagingService
						result = messagingService.SaveMessageThread(saveMessageThreadParam);
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

