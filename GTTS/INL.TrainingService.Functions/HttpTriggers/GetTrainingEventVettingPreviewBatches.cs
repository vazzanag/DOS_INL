using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using INL.PersonService.Client;
using INL.VettingService.Client;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventVettingPreviewBatches
    {
        [FunctionName("GetTrainingEventVettingPreviewBatches")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/participants/batchpreview/{postID}")]HttpRequestMessage request, long trainingEventID, int postID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Fetch the training event
					GetTrainingEventVettingPreviewBatches_Result result = null;
					using (var personServiceClient = await helper.GetPersonServiceClientAsync())
					using (var vettingServiceClient = await helper.GetVettingServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{				
						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = trainingService.GetVettingBatchesPreview(trainingEventID, postID, personServiceClient, vettingServiceClient);
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
