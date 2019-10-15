using System;
using System.Threading.Tasks;
using System.Text;
using System.Data.SqlClient;
using System.Security.Authentication;
using System.Net;
using System.Net.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.UserService.Client;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using INL.PersonService.Client;
using INL.UnitLibraryService.Client;
using INL.LocationService.Client;
using INL.ReferenceService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class ImportTrainingEventParticipants
    {
        [FunctionName("ImportTrainingEventParticipants")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/importtrainingeventparticipants")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var importTrainingEventParticipantsXLSXParam = new ImportTrainingEventParticipantsXLSX_Param { TrainingEventID = trainingEventID };
									   
					// Import the participants
					IImportTrainingEventParticipantsXLSX_Result result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var locationServiceClient = await helper.GetLocationServiceClientAsync())
					using (var personServiceClient = await helper.GetPersonServiceClientAsync())
					using (var referenceServiceClient = await helper.GetReferenceServiceClientAsync())
					using (var unitLibraryServiceClient = await helper.GetUnitLibraryServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						importTrainingEventParticipantsXLSXParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = await trainingService.ImportTrainingEventParticipantsXLSX(importTrainingEventParticipantsXLSXParam, locationServiceClient, personServiceClient, referenceServiceClient, unitLibraryServiceClient);
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
