using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
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

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetParticipantTrainingEvents
    {

        [FunctionName("GetParticipantTrainingEvents")]
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
                    var filter = request.GetQueryParametersAsObject<GetParticipantTrainingEventsFilter>();

                    // Fetch Persons Training Event History
                    IGetPersonsTrainingEvents_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = trainingService.GetParticipantTrainingEvents(personID, filter.TrainingEventStatus);
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

    class GetParticipantTrainingEventsFilter
    {
        public string TrainingEventStatus { get; set; }
    }
}
