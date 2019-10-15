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
    public static class FindCityByCityNameStateNameAndCountryID
    {
        private static Configuration configuration;

        [FunctionName("FindCityByCityNameStateNameAndCountryID")]
        public static async Task<HttpResponseMessage> Run([
            HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "countries/{countryID}/city")]HttpRequestMessage request,
            long countryID,
            ILogger log,
            ExecutionContext context)
        {
            string cityName = request.GetQueryNameValuePairs().Single(p => p.Key == "cityName").Value;
            string stateName = request.GetQueryNameValuePairs().Single(p => p.Key == "stateName").Value;
            bool canCreate = false;
            if (request.GetQueryNameValuePairs().Any(p => p.Key == "canCreate"))
            {
                canCreate = bool.Parse(request.GetQueryNameValuePairs().Single(p => p.Key == "canCreate").Value);
            }
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

                    // Get the location result
                    FindCity_Result result = null;
                    if (!canCreate)
                    {
                        var findParam = new FindCityByCityNameStateNameAndCountryID_Param()
                        {
                            CityName = cityName,
                            StateName = stateName,
                            CountryID = countryID
                        };


                        
                        using (var sqlConnection = await helper.GetSqlConnectionAsync())
                        {
                            var locationRepository = new LocationRepository(sqlConnection);
                            var locationService = new LocationService(locationRepository);

                            result = locationService.FindCityByCityNameStateNameAndCountryID(findParam);
                        }
                    }
                    else
                    {
                        var findParam = new FindOrCreateCityByCityNameStateNameAndCountryID_Param()
                        {
                            CityName = cityName,
                            StateName = stateName,
                            CountryID = countryID
                        };


                        // Get the location result
                        using (var userService = await helper.GetUserServiceClientAsync())
                        using (var sqlConnection = await helper.GetSqlConnectionAsync())
                        {
                            var locationRepository = new LocationRepository(sqlConnection);
                            var locationService = new LocationService(locationRepository);
                            var myUserProfile = await userService.GetMyProfile();
                            findParam.ModifiedbyAppUserID = myUserProfile.UserProfileItem.AppUserID;

                            result = locationService.FindOrCreateCityByCityNameStateNameAndCountryName(findParam);
                        }
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
