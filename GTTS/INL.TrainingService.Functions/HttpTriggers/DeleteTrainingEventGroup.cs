using INL.Functions;
using INL.TrainingService.Data;
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
	public static class DeleteTrainingEventGroup
	{
		[FunctionName("DeleteTrainingEventGroup")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "trainingevents/{trainingEventID}/groups/{trainingEventGroupID}")]HttpRequestMessage request,
			long trainingEventID,
			long trainingEventGroupID,
			ILogger log,
			Microsoft.Azure.WebJobs.ExecutionContext context)
		{

			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Validate input
					if (trainingEventID == 0 || trainingEventGroupID == 0)
					{
						throw new IndexOutOfRangeException();
					}

					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
						var trainingService = new TrainingService(trainingRepository);

						// Call TrainingService
						trainingService.DeleteTrainingEventGroup(trainingEventGroupID);
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
