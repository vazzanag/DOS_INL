using System;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;


namespace INL.TrainingService.Functions.HttpTriggers
{
	public static class DeleteTrainingEventParticipantXLSX
    {
        [FunctionName("DeleteTrainingEventParticipantXLSX")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "trainingevents/{trainingEventID}/previewparticipants/{participantXLSXID}")]HttpRequestMessage request, long trainingEventID, int participantXLSXID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Delete an uploaded training event participant
					IDeleteTrainingEventParticipantXLSX_Result result = null;

					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = trainingService.DeleteTrainingEventParticipantXLSX(new DeleteTrainingEventParticipantXLSX_Param { ParticipantXLSXID = participantXLSXID });
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
