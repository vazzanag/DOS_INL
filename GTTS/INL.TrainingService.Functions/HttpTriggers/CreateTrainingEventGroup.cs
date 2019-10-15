using INL.Functions;
using INL.LocationService.Client;
using INL.PersonService.Client;
using INL.UserService.Client;
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
using System.Threading.Tasks;
using System.Security.Authentication;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class CreateTrainingEventGroup
    {
        [FunctionName("CreateTrainingEventGroup")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents/{trainingEventID}/groups")]HttpRequestMessage request,
            long trainingEventID,
            ILogger log,
            ExecutionContext context)
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
					var saveTrainingEventGroupParam = await request.Content.ReadAsAsyncCustom<SaveTrainingEventGroup_Param>(new TrainingServiceJsonConvertor().JsonConverters);


                    // Validate input
                    if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}
                    
					if (trainingEventID != saveTrainingEventGroupParam.TrainingEventID)
					{
						throw new ArgumentException();
					}

                    // Save the training event
                    ISaveTrainingEventGroup_Result result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventGroupParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = trainingService.SaveTrainingEventGroup(saveTrainingEventGroupParam);
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
