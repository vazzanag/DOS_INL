﻿using INL.BudgetsService.Data;
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
    public static class GetCustomBudgetCategoriesByTrainingEventID
    {
        private static Configuration configuration;

        [FunctionName("GetCustomBudgetCategoriesByTrainingEventID")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/custombudgetcategories")]HttpRequestMessage request,
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

					GetCustomBudgetCategories_Result result;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var budgetsRepository = new BudgetsRepository(sqlConnection);
                        var budgetsService = new BudgetsService(budgetsRepository);

                        result = budgetsService.GetCustomBudgetCategoriesByTrainingEventID(trainingEventID);
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
