using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using System.Security.Authentication;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class SaveTrainingEventVisaCheckLists
    {
        [FunctionName("SaveTrainingEventVisaCheckLists")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingeventid}/visachecklists")]HttpRequestMessage request, long trainingEventID, ILogger log, ExecutionContext context)
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
					var saveTrainingEventVisaCheckListParam = await request.Content.ReadAsAsyncCustom<SaveTrainingEventVisaCheckList_Param>(new TrainingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}
                    else
                    {
                        // Ensure the id on the URL matches the id in the payload
                        if (trainingEventID != saveTrainingEventVisaCheckListParam.TrainingEventID)
						{
							throw new ArgumentException();
						}
                    }

                    // Save the training event
                    IGetTrainingEventVisaCheckLists_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventVisaCheckListParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
						
						// Instantialize TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);
						
						// Call TrainingService
						result = trainingService.SaveTrainingEventVisaCheckLists(saveTrainingEventVisaCheckListParam);
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
