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
    public static class SearchParticipants
    {
        [FunctionName("SearchParticipants")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "participants")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            string searchString = string.Empty;

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

                    // Get input
                    var getParticipantsParam = request.GetQueryParametersAsObject<SearchParticipants_Param>();

                    // Fetch Students
                    ISearchParticipants_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var searchRepository = new SearchRepository(sqlConnection);
                        var searchService = new SearchService(searchRepository);

                        switch (getParticipantsParam.Context.ToLower())
                        {
                            case "trainingevent":
                                if (getParticipantsParam.TrainingEventID.HasValue && getParticipantsParam.TrainingEventID.Value > 0)
                                    result = searchService.SearchParticipants(getParticipantsParam);
                                else
                                    throw new ArgumentException("Invalid training event ID");
                                break;
                            default:
                                if (getParticipantsParam.IncludeVettingOnly.HasValue && getParticipantsParam.IncludeVettingOnly.Value)
                                    result = searchService.SearchParticipantsAndPersons(getParticipantsParam);
                                else if (getParticipantsParam.IncludeVettingOnly.HasValue && !getParticipantsParam.IncludeVettingOnly.Value)
                                    result = searchService.SearchParticipants(getParticipantsParam);
                                else
                                    result = searchService.SearchParticipantsAndPersons(getParticipantsParam);
                                break;
                        }
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
