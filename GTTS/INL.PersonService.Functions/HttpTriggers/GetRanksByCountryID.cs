using INL.Functions;
using INL.PersonService.Data;
using INL.PersonService.Models;
using INL.LocationService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using System.Security.Claims;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Mapster;
using System.Security.Authentication;

namespace INL.PersonService.Functions.HttpTriggers
{
    public static class GetRanksByCountryID
    {
        private static Configuration configuration;

        [FunctionName("GetRanksByCountryID")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "countries/{countryID}/ranks")]HttpRequestMessage request, int countryID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Get function configuration				
					if (configuration == null)
                    {
                        configuration = await FunctionConfigurationLoader<Configuration>.LoadConfigurationFromKeyVault();
                    }

                    // Read input				  
                    if (countryID == 0)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.NotFound, "");
                    }

                    // Fetch All Ranks
                    IGetRanks_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

                        result = personService.GetRanksByCountryID(countryID);
                    }

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
