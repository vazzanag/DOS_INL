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
	public static class GetAllParticipantscs
	{

		[FunctionName("GetAllParticipants")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "countries/{countryID:int}/participants")]HttpRequestMessage request, int countryID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			string personsListParameter = string.Empty;

			using (log.BeginScope(context.InvocationId.ToString()))
			{
				using (log.BeginScope(context.InvocationId.ToString()))
				{
					// Init the FunctionHelper
					var helper = new FunctionHelper(request, context, log);

					try
					{
						// Authorize the user
						helper.AuthorizeUser();

						string typeParam = null;

						// Read input

						var queryParams = request.GetQueryNameValuePairs();
						if (queryParams != null && queryParams.Count() > 0)
						{
							typeParam = ((KeyValuePair<string, string>)queryParams.Single(p => p.Key == "type")).Value;
						}

						// Fetch Persons data
						IGetAllParticipants_Result result = null;
						using (var sqlConnection = await helper.GetSqlConnectionAsync())
						{
							var personRepository = new PersonRepository(sqlConnection);
							var personService = new PersonService(personRepository);

							result = personService.GetAllParticipants(countryID, typeParam);
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
}
