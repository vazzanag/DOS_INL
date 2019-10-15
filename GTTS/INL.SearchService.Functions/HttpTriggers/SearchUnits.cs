using INL.Functions;
using INL.SearchService.Data;
using INL.SearchService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace INL.SearchService.Functions.HttpTriggers
{
    public static class SearchUnits
    {
        [FunctionName("SearchUnits")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "units")]HttpRequestMessage request,
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

                    // Get input
                    var filter = request.GetQueryParametersAsObject<SearchUnits_Param>();

                    ISearchUnits_Result result;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var searchRepository = new SearchRepository(sqlConnection);
                        var searchService = new SearchService(searchRepository);

                        result = searchService.SearchUnits(filter);
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
