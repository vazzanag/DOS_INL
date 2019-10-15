using System;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using INL.UserService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
	public static class UpdateTrainingEventProjectCodes
	{
		[FunctionName("UpdateTrainingEventProjectCodes")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/projectcodes")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveTrainingEventProjectCodesParam = await request.Content.ReadAsAsync<SaveTrainingEventProjectCodes_Param>();
										
					// Validate input
					if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}

					if (trainingEventID != saveTrainingEventProjectCodesParam.TrainingEventID)
					{
						throw new ArgumentException();
					}

					// Save the training event locations
					SaveTrainingEventProjectCodes_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventProjectCodesParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
						var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = trainingService.SaveTrainingEventProjectCodes(saveTrainingEventProjectCodesParam);
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
