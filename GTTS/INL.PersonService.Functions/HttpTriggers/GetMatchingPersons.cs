using System;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Security.Claims;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.PersonService.Models;
using INL.PersonService.Data;
using INL.LocationService.Client;
using System.Security.Authentication;

namespace INL.PersonService.Functions.HttpTriggers
{
    public static class GetMatchingPersons
    {
        private static Configuration configuration;

        [FunctionName("GetMatchingPersons")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "persons/matchedby")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Read input
					var getMatchingPersons_Param = await request.Content.ReadAsAsyncCustom<IGetMatchingPersons_Param>(new PersonServiceJsonConvertor().JsonConverters);
                    
                    IGetMatchingPersons_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

                        result = personService.GetMatchingPersons(getMatchingPersons_Param);
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
