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
    public static class UpdateMessageThread
    {
        [FunctionName("UpdateMessageThread")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "messagethreads/{messageThreadID}")]HttpRequestMessage request,
            long messageThreadID,
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

					var saveMessageThreadParam = await request.Content.ReadAsAsyncCustom<SaveMessageThread_Param>(new MessagingServiceJsonConverter().JsonConverters);

                    // Ensure the id on the URL matches the id in the payload
                    if (messageThreadID != saveMessageThreadParam.Item.MessageThreadID)
					{
						throw new ArgumentException();
					}

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

