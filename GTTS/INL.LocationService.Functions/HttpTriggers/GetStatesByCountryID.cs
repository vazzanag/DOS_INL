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
using INL.LocationService.Models;
using INL.LocationService.Data;

namespace INL.LocationService.Functions.HttpTriggers
{
    public static class GetStatesByCountryID
    {
        [FunctionName("GetStatesByCountryID")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "countries/{countryid}/states")]HttpRequestMessage request, int countryID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Fetch the country's states
					GetStatesByCountryID_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate LocationService
						var locationRepository = new LocationRepository(sqlConnection);
                        var locationService = new LocationService(locationRepository);

                        // Call the LocationService
						result = locationService.GetStatesByCountryID(countryID);
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
