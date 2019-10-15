using INL.Functions;
using INL.PersonService.Data;
using INL.PersonService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;

namespace INL.PersonService.Functions.HttpTriggers
{
    public static class GetPersonUnit
    {

        [FunctionName("GetPersonUnit")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "persons/{personID}/unit")]HttpRequestMessage request, long personID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {

			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Fetch persons data with unit info
					IGetPersonUnit_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

                        result = personService.GetPersonUnit(personID);
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
