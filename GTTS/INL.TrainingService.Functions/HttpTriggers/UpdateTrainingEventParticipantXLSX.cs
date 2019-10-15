using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using INL.UserService.Client;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;

namespace INL.TrainingService.Functions.HttpTriggers
{
	public static class UpdateTrainingEventParticipantXLSX
    {
        [FunctionName("UpdateTrainingEventParticipantXLSX")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingeventid}/uploadparticipants/{participantXLSXID}")]HttpRequestMessage request, long participantXLSXID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveTrainingEventParticipantXLSXParam = await request.Content.ReadAsAsyncCustom<SaveTrainingEventParticipantXLSX_Param>(new TrainingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (participantXLSXID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    if (participantXLSXID != saveTrainingEventParticipantXLSXParam.ParticipantXLSXID)
					{
						throw new ArgumentException();
					}

                    // Save the ParticipantXLSX Item
                    ISaveTrainingEventParticipantXLSX_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					using (var http = new HttpClient())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventParticipantXLSXParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = trainingService.UpdateTrainingEventParticipantXLSX(saveTrainingEventParticipantXLSXParam);
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

