using System;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using System.Security.Authentication;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class DeleteTrainingEventParticipant
    {
        private static Configuration configuration;

        [FunctionName("DeleteTrainingEventParticipant")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "trainingevents/{trainingEventID}/participant/{participantID}/participantType/{participantType}")]HttpRequestMessage request, long trainingEventID, string participantType, long participantID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Delete a training event participant
					IDeleteTrainingEventParticipant_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = trainingService.DeleteTrainingEventParticipant(new DeleteTrainingEventParticipant_Param { TrainingEventID = trainingEventID, ParticipantID = participantID, ParticipantType = participantType});
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
