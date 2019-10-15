using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Security.Claims;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;

using INL.Functions;
using INL.UnitLibraryService.Models;
using INL.UnitLibraryService.Data;
using System.Security.Authentication;

namespace INL.UnitLibraryService.Functions.HttpTriggers
{
    public static class GetUnitNextGenID
    {
        private static Configuration configuration;

        [FunctionName("GetNextUnitGenID")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get",  Route = "countries/{countryID}/agencies/{unitID}/nextunitgenid")]HttpRequestMessage request, int countryID, long unitID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					GetNextUnitGenID_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository);

                        result = unitLibraryService.GetNextUnitGenID(countryID, unitID);
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
