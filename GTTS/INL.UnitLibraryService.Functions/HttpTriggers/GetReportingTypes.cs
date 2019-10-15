using INL.UnitLibraryService.Data;
using INL.UnitLibraryService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace INL.UnitLibraryService.Functions.HttpTriggers
{
    public class GetReportingTypes
    {
        [FunctionName("GetReportingTypes")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "countries/reportingtypes")]HttpRequestMessage request,            
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

                    GetReportingTypes_Result result = null;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var unitLibraryRepo = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepo);

                        result = unitLibraryService.GetReportingTypes();
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
