using INL.Functions;
using INL.LocationService.Data;
using INL.LocationService.Models;
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

namespace INL.LocationService.Functions.HttpTriggers
{
    public static class FindCityByCityNameStateNameAndCountryName
    {
        private static Configuration configuration;

        [FunctionName("FindCityByCityNameStateNameAndCountryName")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "city")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            string cityName = request.GetQueryNameValuePairs().Single(p => p.Key == "cityName").Value;
            string stateName = request.GetQueryNameValuePairs().Single(p => p.Key == "stateName").Value;
            string countryName = request.GetQueryNameValuePairs().Single(p => p.Key == "countryName").Value;
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					var findParam = new FindCityByCityNameStateNameAndCountryName_Param()
                    {
                        CityName = cityName,
                        StateName = stateName,
                        CountryName = countryName
                    };

                    // Get the location result
                    FindCity_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var locationRepository = new LocationRepository(sqlConnection);
                        var locationService = new LocationService(locationRepository);

                        result = locationService.FindCityByCityNameStateNameAndCountryName(findParam);
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
