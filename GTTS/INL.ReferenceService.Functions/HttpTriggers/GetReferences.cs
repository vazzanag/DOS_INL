using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.ReferenceService.Data;
using INL.ReferenceService.Models;


namespace INL.ReferenceService.Functions.HttpTriggers
{
    public static class GetReferences
    {
        [FunctionName("GetReferences")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "references")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            string referenceList = string.Empty;
            int? countryId = null;
            int? postId = null;

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
                        var parms = request.GetQueryNameValuePairs();
                        referenceList = (parms.Single(p => p.Key.ToLower() == "referencelist")).Value;
                        if (null != (parms.SingleOrDefault(p => p.Key.ToLower() == "countryid")).Value)
                            countryId = int.Parse((parms.SingleOrDefault(p => p.Key.ToLower() == "countryid")).Value);
                        if (null != (parms.SingleOrDefault(p => p.Key.ToLower() == "postid")).Value)
                            postId = int.Parse((parms.SingleOrDefault(p => p.Key.ToLower() == "postid")).Value);
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Errors occurred while obtaining query string values", ex);
                    }

                    var getReferenceTableParam = new GetReferenceTable_Param
                    {
                        ReferenceList = referenceList,
                        CountryID = countryId,
                        PostID = postId
                    };

                    // Fetch Training Event reference data
                    ReferenceTables_Results result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate ReferenceService
						var referenceRepository = new ReferenceRepository(sqlConnection);
                        var referenceService = new ReferenceService(referenceRepository);

						// Call the ReferenceService
						result = referenceService.GetReferences(getReferenceTableParam);
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
