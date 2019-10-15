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
    public static class UpdateTrainingEventLocations
	{
		[FunctionName("UpdateTrainingEventLocations")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/locations")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Read input
					var saveTrainingEventLocationsParam = await request.Content.ReadAsAsync<SaveTrainingEventLocations_Param>();
					
					// Validate input
					if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}

					if (trainingEventID != saveTrainingEventLocationsParam.TrainingEventID)
					{
						throw new ArgumentException();
					}

					// Save the training event locations
					SaveTrainingEventLocations_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var locationServiceClient = await helper.GetLocationServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventLocationsParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
						var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = await trainingService.SaveTrainingEventLocations(saveTrainingEventLocationsParam, locationServiceClient);
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

