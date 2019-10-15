using INL.MessagingService.Data;
using INL.MessagingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;

namespace INL.MessagingService.Functions.HttpTriggers
{
	public static class GetMessageThreadParticipantsByAppUserID
	{
		[FunctionName("GetMessageThreadParticipantsByAppUserID")]
		public static async Task<HttpResponseMessage> Run(
			[HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "users/{appUserID}/messagethreads")]HttpRequestMessage request,
			long appUserID,
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

					int pageIndex = int.Parse(request.GetQueryNameValuePairs().Single(p => p.Key == "pageIndex").Value);
					int pageSize = int.Parse(request.GetQueryNameValuePairs().Single(p => p.Key == "pageSize").Value);

					GetMessageThreadParticipants_Result result;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						var messagingRepository = new MessagingRepository(sqlConnection);
						var messagingService = new MessagingService(messagingRepository);

						result = messagingService.GetMessageThreadParticipantsByAppUserID(appUserID, pageIndex, pageSize);						
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
