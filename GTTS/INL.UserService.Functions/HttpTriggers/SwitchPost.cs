using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;
using System.Linq;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.UserService.Data;
using INL.UserService.Models;

namespace INL.UserService.Functions.HttpTriggers
{
    public static class SwitchPost
	{
		[FunctionName("SwitchPost")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "users/{appUserID}/post")]HttpRequestMessage request, int appUserID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					if (!helper.GetMyAppRoles().Contains("INLGLOBALADMIN"))
					{
						throw new AuthenticationException("NOT AUTHORIZED");
					}

					// Get parameter
					var postID = await request.Content.ReadAsStringAsync();

					// Switch the user's post
					ISwitchPost_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Instantiate UserService
						var userRepository = new UserRepository(sqlConnection);
						var userService = new UserService(userRepository);

						// Call UserService
						result = userService.SwitchPost(appUserID, int.Parse(postID));
					}

					return request.CreateResponse(HttpStatusCode.OK, result, "application/json");
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
		}
	}
}
