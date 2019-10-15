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
using INL.UserService.Client;
using INL.PersonService.Client;
using INL.TrainingService.Models;
using INL.TrainingService.Data;


namespace INL.TrainingService.Functions.HttpTriggers
{
	public static class AddParticipantToTrainingEvent
	{
		[FunctionName("AddParticipantToTrainingEvent")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents/{trainingeventid}/participants")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveTrainingEventParticipant_Param = await request.Content.ReadAsAsyncCustom<ISaveTrainingEventPersonParticipant_Param>(new TrainingServiceJsonConvertor().JsonConverters);

					// Ensure the trainingeventID was passed on the URL and matches the id in the payload
					if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}

					if (trainingEventID != saveTrainingEventParticipant_Param.TrainingEventID)
					{
						throw new ArgumentException();
					}

					// Save the training event participant
					ISaveTrainingEventParticipant_Result result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var personServiceClient = await helper.GetPersonServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventParticipant_Param.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
						var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = await trainingService.SaveTrainingEventParticipant(saveTrainingEventParticipant_Param, personServiceClient);
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
