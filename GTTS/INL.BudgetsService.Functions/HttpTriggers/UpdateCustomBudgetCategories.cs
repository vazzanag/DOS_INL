using INL.BudgetsService.Data;
using INL.BudgetsService.Models;
using INL.Functions;
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

namespace INL.BudgetsService.Functions.HttpTriggers
{
    public static class UpdateCustomBudgetCategories
    {
        private static Configuration configuration;

        [FunctionName("UpdateCustomBudgetCategories")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/custombudgetcategories")]HttpRequestMessage request,
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

					// Read input
					var param = await request.Content.ReadAsAsyncCustom<SaveCustomBudgetCategories_Param>(new BudgetsServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (trainingEventID == 0 || trainingEventID == 0)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.NotFound, "");
                    }
                    param.TrainingEventID = trainingEventID;
                    // Save the training event
                    SaveCustomBudgetCategories_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						param.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
						param.CustomBudgetCategories.ForEach(b => b.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID);

						var budgetsRepo = new BudgetsRepository(sqlConnection);
                        var budgetsService = new BudgetsService(budgetsRepo);

                        result = budgetsService.SaveCustomBudgetCategories(param);
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
