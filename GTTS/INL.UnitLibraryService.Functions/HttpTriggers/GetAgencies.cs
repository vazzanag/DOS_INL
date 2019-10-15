using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;

using INL.Functions;
using INL.UnitLibraryService.Models;
using INL.UnitLibraryService.Data;

namespace INL.UnitLibraryService.Functions
{
    public static class GetAgencies
    {
        [FunctionName("GetAgencies")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "countries/{countryID}/agencies")]HttpRequestMessage request, int countryID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            int? PageSize;
            int? PageNumber;
            string SortDirection;
            string SortColumn;
            bool? IsMainAgency;
            bool? IsActive;

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Read input
					try
					{
                        var parms = request.GetQueryNameValuePairs();

                        int intTryParseOutput;
                        bool boolTryParseOutput;

                        if (int.TryParse(((KeyValuePair<string, string>)parms.Single(p => p.Key.ToLower() == "pagesize")).Value, out intTryParseOutput))
                            PageSize = intTryParseOutput;
                        else
                            PageSize = null;

                        if (int.TryParse(((KeyValuePair<string, string>)parms.Single(p => p.Key.ToLower() == "pagenumber")).Value, out intTryParseOutput))
                            PageNumber = intTryParseOutput;
                        else
                            PageNumber = null;

                        SortDirection = (((KeyValuePair<string, string>)parms.Single(p => p.Key.ToLower() == "sortdirection")).Value);
                        SortColumn = (((KeyValuePair<string, string>)parms.Single(p => p.Key.ToLower() == "sortcolumn")).Value);

                        if (bool.TryParse(((KeyValuePair<string, string>)parms.Single(p => p.Key.ToLower() == "isactive")).Value, out boolTryParseOutput))
                            IsActive = boolTryParseOutput;
                        else
                            IsActive = null;

                        IsMainAgency = bool.Parse(((KeyValuePair<string, string>)parms.Single(p => p.Key.ToLower() == "ismainagency")).Value);
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Errors occurred while obtaining query string values", ex);
                    }

                    // Validate input
                    if (countryID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    var getAgenciesPaged = new GetUnitsPaged_Param
                    {
                        PageSize = PageSize,
                        PageNumber = PageNumber,
                        SortDirection = SortDirection,
                        SortColumn = SortColumn,
                        CountryID = countryID,
                        IsMainAgency = IsMainAgency,
                        UnitMainAgencyID = null,
                        IsActive = IsActive
                    };

                    // Create result object
                    GetUnitsPaged_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository);

                        result = unitLibraryService.GetAgenciesPaged(getAgenciesPaged);
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
