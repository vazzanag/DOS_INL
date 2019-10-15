using INL.Functions;
using INL.UserService.Data;
using INL.UserService.Models;
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


namespace INL.UserService.Functions.HttpTriggers
{
    public class GetAppUsers
	{
        [FunctionName("GetAppUsers")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "users")]HttpRequestMessage request, ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Get input
					var filter = request.GetQueryParametersAsObject<GetAppUsersFilter>();

					// Get AppUsers
					IGetAppUsers_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var userRepository = new UserRepository(sqlConnection);
                        var userService = new UserService(userRepository);

						// Call UserService
                        result = userService.GetAppUsers(filter.CountryID, filter.PostID, filter.AppRoleID, filter.BusinessUnitID);
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


class GetAppUsersFilter {
	public int? CountryID { get; set; }
	public int? PostID { get; set; }
	public int? AppRoleID { get; set; }
	public int? BusinessUnitID { get; set; }

}
