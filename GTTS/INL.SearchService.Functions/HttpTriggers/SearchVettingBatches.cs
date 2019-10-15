using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using System.Security.Claims;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using INL.Functions;
using INL.SearchService.Models;
using INL.SearchService.Data;
using System.Security.Authentication;

namespace INL.SearchService.Functions.HttpTriggers
{
    public static class SearchVettingBatches
    {
        private static Configuration configuration;

        [FunctionName("SearchVettingBatches")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "vettingbatches")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            string searchString = string.Empty;
            int? countryID;
            string filterStatus = string.Empty;

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Get function configuration				
					if (configuration == null)
                    {
                        configuration = await FunctionConfigurationLoader<Configuration>.LoadConfigurationFromKeyVault();
                    }

                    // Read input
                    try
                    {
                        int intTryParseOutput;
                        var parms = request.GetQueryNameValuePairs();
                        searchString = ((KeyValuePair<string, string>)parms.Single(p => p.Key == "searchString")).Value;

                        if (int.TryParse(((KeyValuePair<string, string>)parms.Single(p => p.Key == "countryID")).Value, out intTryParseOutput))
                            countryID = intTryParseOutput;
                        else
                            countryID = null;

                        filterStatus = ((KeyValuePair<string, string>)parms.Single(p => p.Key == "filterStatus")).Value;

                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Errors occurred while obtaining query string values", ex);
                    }

                    // Initialize SearchService parameter
                    var searchVettingBatchesParam = new SearchVettingBatches_Param
                    {
                        SearchString = searchString,
                        CountryID = countryID,
                        FilterStatus = filterStatus
                    };

                    // Fetch Instructors
                    ISearchVettingBatches_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var searchRepository = new SearchRepository(sqlConnection);
                        var searchService = new SearchService(searchRepository);

                        result = searchService.SearchVettingBatches(searchVettingBatchesParam);
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
