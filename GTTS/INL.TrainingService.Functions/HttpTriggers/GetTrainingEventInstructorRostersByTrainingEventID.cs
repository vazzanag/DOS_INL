using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using System.Security.Authentication;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventInstructorRostersByTrainingEventID
    {
        [FunctionName("GetTrainingEventInstructorRostersByTrainingEventID")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/rosters/instructors")]HttpRequestMessage request, 
            long trainingEventID, ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Fetch the training event participants
					IGetTrainingEventRosterInGroups_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Instantiate TrainingService
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call TrainingService
                        result = trainingService.GetTrainingEventInstructorRostersByTrainingEventID(trainingEventID);
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
