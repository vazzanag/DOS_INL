using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Security.Claims;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class GetPersonVettingHits
    {

        [FunctionName("GetPersonVettingHits")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "personvettings/{personVettingID}/vettinghits")]HttpRequestMessage request, long personVettingID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    int vettingTypeID = 0;
                    try
                    {
                        var parms = request.GetQueryNameValuePairs();
                        int vettingTypeIDOut;
                        if (int.TryParse(((KeyValuePair<string, string>)parms.Single(p => p.Key == "vettingTypeID")).Value, out vettingTypeIDOut))
                            vettingTypeID = vettingTypeIDOut;
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Errors occurred while obtaining query string values", ex);
                    }

                    // Fetch the vetting status
                    IGetPersonsVettingHit_Result result = null;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);
                        result = vettingService.GetPersonsVettingHits(personVettingID, vettingTypeID);
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
