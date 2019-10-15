using INL.DocumentService.Client;
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
using System.Web.Http;
using System.Security.Authentication;

namespace INL.MessagingService.Functions.HttpTriggers
{
    public static class UpdateMessageThreadMessage
    {
        [FunctionName("UpdateMessageThreadMessage")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "messagethreads/{messageThreadID}/messages/{messageID}")]HttpRequestMessage request,
            long messageThreadID,
            long messageID,
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
					byte[] fileContent = null;
					var saveMessageThreadMessageParam = request.Content.ReadAsMultipartAsyncCustom<SaveMessageThreadMessage_Param>(out fileContent, new MessagingServiceJsonConverter().JsonConverters);
					if (saveMessageThreadMessageParam == null)
					{
						throw new ArgumentException();
					}
					else if (fileContent == null || fileContent.Length <= 0)
					{
						throw new ArgumentException("NO FILE");
					}

					// Ensure the id on the URL matches the id in the payload
					if (messageThreadID != saveMessageThreadMessageParam.Item.MessageThreadID
                        && messageID != saveMessageThreadMessageParam.Item.MessageThreadMessageID)
					{
						throw new ArgumentException();
					}

					// Save the Message Thread Message
					SaveMessageThreadMessage_Result result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveMessageThreadMessageParam.Item.SenderAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate MessagingService
						var messagingRepository = new MessagingRepository(sqlConnection);
                        var messagingService = new MessagingService(messagingRepository);

                        // Call the MessagingService
						result = await messagingService.SaveMessageThreadMessageAsync(saveMessageThreadMessageParam, fileContent, documentServiceClient);
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

