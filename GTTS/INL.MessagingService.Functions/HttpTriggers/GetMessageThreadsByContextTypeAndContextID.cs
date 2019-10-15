using INL.Functions;
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
    public static class GetMessageThreadsByContextTypeAndContextID
    {
        [FunctionName("GetMessageThreadsByContextTypeAndContextID")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "contexttypes/{contextTypeID}/contexts/{contextID}/messagethreads")]HttpRequestMessage request,
            long contextTypeID,
            long contextID,
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


					// Fetch the Message Threads
					GetMessageThreads_Result result;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Instantiate MessagingService
						var messagingRepository = new MessagingRepository(sqlConnection);
                        var messagingService = new MessagingService(messagingRepository);

						// Call the MessagingService
						result = messagingService.GetMessageThreadsByContextTypeIDAndContextID(contextTypeID, contextID);
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

