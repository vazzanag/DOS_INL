using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.SearchService.Models;
using INL.SearchService.Data;


namespace INL.SearchService.Functions.HttpTriggers
{
    public static class GetInstructors
    {
        [FunctionName("GetInstructors")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "instructors")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            string searchString = string.Empty;
            int? countryID;

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Get parameter
					try
					{
						int intTryParseOutput;
						var param = request.GetQueryNameValuePairs();

						searchString = (param.Single(p => p.Key.ToLower() == "search")).Value;

						if (int.TryParse((param.Single(p => p.Key.ToLower() == "countryid")).Value, out intTryParseOutput))
							countryID = intTryParseOutput;
						else
							countryID = null;
					}
					catch (Exception ex)
					{
						throw new ArgumentException("Errors occurred while obtaining query string values", ex);
					}
					
					var getInstructorsParam = new GetInstructors_Param
                    {
                        SearchString = searchString,
                        CountryID = countryID
                    };

                    // Fetch Instructors
                    IGetInstructors_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Instantiate SearchService
						var searchRepository = new SearchRepository(sqlConnection);
                        var searchService = new SearchService(searchRepository);

						// Call the SearchService
						result = searchService.GetInstructors(getInstructorsParam);
                    }

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
