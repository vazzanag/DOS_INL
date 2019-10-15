using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Data.SqlClient;
using System.Security.Authentication;
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
    public static class UpdateUnitActiveFlag
    {
        [FunctionName("UpdateUnitActiveFlag")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "units/{unitID}/unitactiveflag")]HttpRequestMessage request, int unitID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var updateUnitActiveFlagParam = await request.Content.ReadAsAsync<UpdateUnitActiveFlag_Param>();

                    // Validate input
                    if (unitID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    if (unitID != updateUnitActiveFlagParam.UnitID)
					{
						throw new ArgumentException();
					}


                    // Create result object
                    IUpdateUnitActiveFlag_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository);

                        result = unitLibraryService.UpdateUnitActiveFlag(updateUnitActiveFlagParam);
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
