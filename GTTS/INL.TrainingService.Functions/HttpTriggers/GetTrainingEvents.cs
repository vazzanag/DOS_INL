using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Linq;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using INL.TrainingService.Models;
using INL.TrainingService.Data;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEvents
	{

		[FunctionName("GetTrainingEvents")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// If the URL contains a countryID query parameter, capture it
					int? countryID = null;
					var v = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key.ToLower() == "countryid");
					if (!string.IsNullOrWhiteSpace(v.Value))
					{
						int tryParseCountryID;
						int.TryParse(v.Value, out tryParseCountryID);
						if (tryParseCountryID > 0) countryID = tryParseCountryID;
					}

					// Fetch the training events
					GetTrainingEvents_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// If no countryID was specified in the query parameters, grab the user's default CountryID
						if (!countryID.HasValue)
						{
							var myUserProfile = await userService.GetMyProfile();
							countryID = myUserProfile.UserProfileItem.CountryID;
						}

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
						var trainingService = new TrainingService(trainingRepository);

						// Call TrainingService
						result = trainingService.GetTrainingEventsByCountryID(countryID.GetValueOrDefault(-1));
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
