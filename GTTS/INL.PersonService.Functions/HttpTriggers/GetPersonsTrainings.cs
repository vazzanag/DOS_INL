using INL.Functions;
using INL.PersonService.Data;
using INL.PersonService.Models;
using INL.TrainingService.Client;
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
    public static class GetPersonsTrainings
    {

        [FunctionName("GetPersonsTrainings")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "persons/{personID:int}/trainingevents")]HttpRequestMessage request, long personID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
                    var filter = request.GetQueryParametersAsObject<GetPersonsTrainingsFilter>();

                    // Fetch Persons Training Event History
                    IGetPersonsTraining_Result result = null;
					using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);
                        
						result = personService.GetPersonsTrainings(personID, trainingServiceClient, filter.TrainingEventStatus);
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

    class GetPersonsTrainingsFilter
    {
        public string TrainingEventStatus { get; set; }
    }
}
