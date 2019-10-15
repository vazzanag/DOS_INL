using INL.Functions;
using INL.UserService.Client;
using INL.MessagingService;
using INL.MessagingService.Data;
using INL.MessagingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Security.Authentication;

namespace INL.MessagingService.Functions.HttpTriggers
{
    public static class CreateMessageThreadMessage
    {
        [FunctionName("CreateMessageThreadMessage")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "messagethreads/{messageThreadID}/messages")]HttpRequestMessage request,
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

					// Get parameter
					byte[] attachmentContent = null;
					SaveMessageThreadMessage_Param saveMessageThreadMessageParam = null;
					if (request.Content.IsMimeMultipartContent())
					{
						var provider = new MultipartMemoryStreamProvider();
						await request.Content.ReadAsMultipartAsync(provider);
						foreach (var content in provider.Contents)
						{
							string name = content.Headers.ContentDisposition.Name.Trim('\"');

							switch (name)
							{
								case "file":
									attachmentContent = await content.ReadAsByteArrayAsync();
									break;
								case "params":
									saveMessageThreadMessageParam = await content.ReadAsAsyncCustom<SaveMessageThreadMessage_Param>(new MessagingServiceJsonConverter().JsonConverters);
									break;
								default:
									break;
							}
						}
					}
					else
					{
						saveMessageThreadMessageParam = await request.Content.ReadAsAsyncCustom<SaveMessageThreadMessage_Param>(new MessagingServiceJsonConverter().JsonConverters);
					}

					if (saveMessageThreadMessageParam == null)
					{
						throw new HttpResponseException(HttpStatusCode.BadRequest);
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
						result = await messagingService.SaveMessageThreadMessageAsync(saveMessageThreadMessageParam, attachmentContent, documentServiceClient);
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

