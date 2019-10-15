using System;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Security.Claims;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Mapster;
using INL.Functions;
using INL.TrainingService.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using System.Security.Authentication;
using INL.UserService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class CloseTrainingEvent
    {
        [FunctionName("CloseTrainingEvent")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents/{trainingEventID}/close")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var closeTrainingEventParam = await request.Content.ReadAsAsyncCustom<CloseTrainingEvent_Param>(new TrainingServiceJsonConvertor().JsonConverters);
					
					// Validate input
					if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}

					if (trainingEventID != closeTrainingEventParam.TrainingEventID)
					{
						throw new ArgumentException();
					}
					
                    // Close this event
                    ICloseTrainingEvent_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						closeTrainingEventParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call TrainingService
                        result = trainingService.CloseEvent(closeTrainingEventParam);
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
