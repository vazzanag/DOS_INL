using System;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.UnitLibraryService.Models;
using INL.UnitLibraryService.Data;

namespace INL.UnitLibraryService.Functions.HttpTriggers
{
    public static class GetUnit
    {
        [FunctionName("GetUnit")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "units/{unitID}")]HttpRequestMessage request, long unitID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Create result object
					GetUnit_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository);

                        result = unitLibraryService.GetUnit(unitID);
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
