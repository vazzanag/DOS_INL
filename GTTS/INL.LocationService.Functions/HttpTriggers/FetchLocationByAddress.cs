using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.UserService.Client;
using INL.LocationService.Data;
using INL.LocationService.Models;

namespace INL.LocationService.Functions.HttpTriggers
{
	public static class FetchLocationByAddress
	{
		[FunctionName("FetchLocationByAddress")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "locations")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var fetchLocationParam = await request.Content.ReadAsAsyncCustom<FetchLocationByAddress_Param>(new LocationServiceJsonConverter().JsonConverters);

					// Fetch the location
					IFetchLocationByAddress_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						fetchLocationParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate LocationService
						var locationRepository = new LocationRepository(sqlConnection);
						var locationService = new LocationService(locationRepository);

						// Call the LocationService
						result = locationService.FetchLocationByAddress(fetchLocationParam);
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

