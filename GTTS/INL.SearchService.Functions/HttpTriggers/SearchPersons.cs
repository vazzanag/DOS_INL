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

    public static class SearchPersons
    {
        private static Configuration configuration;

        [FunctionName("SearchPersons")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "persons")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            string searchString = string.Empty;
            int? countryID;
            int? pageSize;
            int? pageNumber;
            string orderColumn = string.Empty;
            string orderDirection = string.Empty;
            string participantType = string.Empty;

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

                        if (int.TryParse((param.Single(p => p.Key.ToLower() == "pagesize")).Value, out intTryParseOutput))
                            pageSize = intTryParseOutput;
                        else
                            pageSize = null;

                        if (int.TryParse((param.Single(p => p.Key.ToLower() == "pagenumber")).Value, out intTryParseOutput))
                            pageNumber = intTryParseOutput;
                        else
                            pageNumber = null;

                        orderColumn = (param.Single(p => p.Key.ToLower() == "ordercolumn")).Value;
                        orderDirection = (param.Single(p => p.Key.ToLower() == "orderdirection")).Value;
                        participantType = (param.Single(p => p.Key.ToLower() == "participanttype")).Value;
                    }
					catch (Exception ex)
					{
						throw new ArgumentException("Errors occurred while obtaining query string values", ex);
					}

					// Initialize SearchService parameter
					var searchPersonsParam = new SearchPersons_Param
					{
						SearchString = searchString,
						CountryID = countryID,
                        OrderColumn = orderColumn,
                        OrderDirection = orderDirection,
                        PageNumber = pageNumber,
                        PageSize = pageSize,
                        ParticipantType = participantType
                    };

					// Search for persons
					ISearchPersons_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var searchRepository = new SearchRepository(sqlConnection);
                        var searchService = new SearchService(searchRepository);

                        // Call the SearchService
                        int recordsFiltered;
                        result = searchService.SearchPersons(searchPersonsParam, out recordsFiltered);
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
