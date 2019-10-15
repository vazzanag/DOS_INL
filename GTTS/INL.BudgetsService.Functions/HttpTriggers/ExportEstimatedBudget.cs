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
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace INL.BudgetsService.Functions.HttpTriggers
{
    public class ExportEstimatedBudget
    {
        private static Configuration configuration;

        [FunctionName("ExportEstimatedBudget")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "budgets/estimatefile")]HttpRequestMessage request,
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

					var param = await request.Content.ReadAsAsyncCustom<ExportEstimatedBudgetCalculator_Params>(new BudgetsServiceJsonConvertor().JsonConverters);
                    ExportEstimatedBudgetCalculator_Result result = null;

					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{

						var budgetsRepository = new BudgetsRepository(sqlConnection);
                        var budgetsService = new BudgetsService(budgetsRepository);

                        result = budgetsService.ExportEstimatedBudgetCalculator(param, context.FunctionAppDirectory);

                        //return attachment
                        var response = request.CreateResponse(HttpStatusCode.OK);
                        response.Content = new ByteArrayContent(result.FileContent);
                        response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                        response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                        {
                            FileName = result.FileName
                        };

                        return response;
                    }
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
		}
	}
}

