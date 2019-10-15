using INL.Functions;
using INL.PersonService.Client;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventInstructorByPersonIDAndTrainingEventID
    {
        [FunctionName("GetTrainingEventInstructorByPersonIDAndTrainingEventID")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/instructors/{personID}")]HttpRequestMessage request,
            long trainingEventID,
            long personID,
            ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					GetTrainingEventInstructor_Result result = null;

					using (var personServiceClient = await helper.GetPersonServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = await trainingService.GetTrainingEventInstructorByPersonIDAndTrainingEventID(personID, trainingEventID, personServiceClient);
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
