using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Authentication;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using INL.ReferenceService.Client;
using INL.UnitLibraryService.Client;
using INL.PersonService.Client;
using INL.LocationService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class PreviewTrainingEventParticipants
    {
        [FunctionName("PreviewTrainingEventParticipants")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/previewparticipants")]HttpRequestMessage request, int trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Preview/Get the uploaded training event participants
					IGetTrainingEventParticipantsXLSX_Result result = null;
					using (var locationServiceClient = await helper.GetLocationServiceClientAsync())
					using (var personServiceClient = await helper.GetPersonServiceClientAsync())
					using (var referenceServiceClient = await helper.GetReferenceServiceClientAsync())
					using (var unitLibraryServiceClient = await helper.GetUnitLibraryServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = await trainingService.GetTrainingEventParticipantsXLSX(trainingEventID, locationServiceClient, personServiceClient, referenceServiceClient, unitLibraryServiceClient);
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
