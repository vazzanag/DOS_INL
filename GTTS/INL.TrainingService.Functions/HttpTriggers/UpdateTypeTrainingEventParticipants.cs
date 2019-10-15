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

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class UpdateTypeTrainingEventParticipants
    {
        [FunctionName("UpdateTypeTrainingEventParticipants")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/participantsType")]HttpRequestMessage request,
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

					var param = await request.Content.ReadAsAsyncCustom<UpdateTypeTrainingEventParticipants_Param>(new TrainingServiceJsonConvertor().JsonConverters);
                    param.TrainingEventID = trainingEventID;

                    using (var vettingService = await helper.GetVettingServiceClientAsync())
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();
                        var modifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

                        trainingService.UpdateTypeTrainingEventParticipants(param, vettingService, modifiedByAppUserID);
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

