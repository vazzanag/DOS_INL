using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using INL.LocationService.Client;
using INL.PersonService.Client;
using INL.UserService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class UpdateTrainingEventParticipant
    {
        [FunctionName("UpdateTrainingEventParticipant")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingeventid}/participants/{participantid}")]
            HttpRequestMessage request, long trainingeventid, long participantid, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveTrainingEventPersonParticipantParam = await request.Content.ReadAsAsyncCustom<SaveTrainingEventPersonParticipant_Param>(new TrainingServiceJsonConvertor().JsonConverters);
					
                    // Validate input
                    if (trainingeventid == 0 || participantid == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    if (trainingeventid != saveTrainingEventPersonParticipantParam.TrainingEventID 
                        || participantid != saveTrainingEventPersonParticipantParam.ParticipantID)
					{
						throw new ArgumentException();
					}

                    // Save the training event
                    ISaveTrainingEventParticipant_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var personServiceClient = await helper.GetPersonServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventPersonParticipantParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = await trainingService.SaveTrainingEventParticipantWithPersonDataAsync(saveTrainingEventPersonParticipantParam, false, personServiceClient);
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
