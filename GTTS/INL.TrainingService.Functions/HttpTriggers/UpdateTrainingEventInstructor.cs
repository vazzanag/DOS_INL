using INL.Functions;
using INL.LocationService.Client;
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
using System.Threading.Tasks;
using System.Security.Authentication;
using INL.UserService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class UpdateTrainingEventInstructor
    {
        [FunctionName("UpdateTrainingEventInstructor")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/instructors/{personID}")]HttpRequestMessage request,
            long trainingEventID,
            long personID,
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

					// Read input
					var saveTrainingEventInstructorParam = await request.Content.ReadAsAsyncCustom<SaveTrainingEventInstructor_Param>(new TrainingServiceJsonConvertor().JsonConverters);
					
                    // Validate input
                    if (trainingEventID == 0 || personID == 0)
					{
						throw new IndexOutOfRangeException();
					}
                    
					if (trainingEventID != saveTrainingEventInstructorParam.TrainingEventID
                        || personID != saveTrainingEventInstructorParam.PersonID)
					{
						throw new ArgumentException();
					}

                    // Save the training event
                    ISaveTrainingEventInstructor_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventInstructorParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = trainingService.SaveTrainingEventInstructor(saveTrainingEventInstructorParam);
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
