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
using INL.LocationService.Client;
using INL.UserService.Client;


namespace INL.TrainingService.Functions.HttpTriggers
{   
    public static class CreateTrainingEvent
	{
        [FunctionName("CreateTrainingEvent")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveTrainingEventParam = await request.Content.ReadAsAsyncCustom<SaveTrainingEvent_Param>(new TrainingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    // POSTs are for new records.  The payload should not have an id because it is system generated.
                    saveTrainingEventParam.TrainingEventID = -1;

					// Save the training event
					ISaveTrainingEvent_Result result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var locationServiceClient = await helper.GetLocationServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
						saveTrainingEventParam.TrainingEventLocations?.ForEach(l => l.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID);
						saveTrainingEventParam.CountryID = saveTrainingEventParam.CountryID.GetValueOrDefault(myUserProfile.UserProfileItem.CountryID.Value);
						saveTrainingEventParam.PostID = saveTrainingEventParam.PostID.GetValueOrDefault(myUserProfile.UserProfileItem.PostID.Value);

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
						var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = await trainingService.SaveTrainingEvent(saveTrainingEventParam, locationServiceClient);
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
