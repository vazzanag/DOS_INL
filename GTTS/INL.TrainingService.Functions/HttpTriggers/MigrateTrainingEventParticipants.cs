using INL.Functions;
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
    public static class MigrateTrainingEventParticipants
    {
        [FunctionName("MigrateTrainingEventParticipants")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/participantsmigrate")]HttpRequestMessage request,
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

					var migrateTrainingEventParticipantsParam = await request.Content.ReadAsAsyncCustom<MigrateTrainingEventParticipants_Param>(new TrainingServiceJsonConvertor().JsonConverters);
                    migrateTrainingEventParticipantsParam.TrainingEventID = trainingEventID;

					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						migrateTrainingEventParticipantsParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						trainingService.MigrateTrainingEventParticipants(migrateTrainingEventParticipantsParam);
                    }


                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK);
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
		}
	}
}
