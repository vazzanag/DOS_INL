using INL.Functions;
using INL.PersonService.Data;
using INL.PersonService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;


namespace INL.PersonService.Functions.HttpTriggers
{
    public static class GetPersons
    {
        [FunctionName("GetPersons")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "persons")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					long[] personIDs = null;
					try
					{
						var personIDsString = request.GetQueryNameValuePairs().Single(p => p.Key.ToLower() == "ids").Value;
						var personIDsStringList = personIDsString.Split(',');
						personIDs = Array.ConvertAll(personIDsStringList, long.Parse);
						if (personIDs == null || personIDs.Length == 0) {
							throw new ArgumentException("No person IDs provided.");
						}
					}
                    catch (Exception ex)
                    {
                        throw new ArgumentException("Errors occurred while obtaining query string values.", ex);
                    }

                    // Fetch the persons
                    IGetPersonsWithUnitLibraryInfo_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Instantiate PersonService
						var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

						// Call the PersonService
						result = personService.GetPersonsWithUnitLibraryInfoFromArray(personIDs);
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

