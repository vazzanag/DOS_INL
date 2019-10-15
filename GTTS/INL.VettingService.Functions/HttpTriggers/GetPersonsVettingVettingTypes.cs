using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;


namespace INL.VettingService.Functions.HttpTriggers
{
    public static class GetPersonsVettingVettingTypes
    {

        [FunctionName("GetPersonsVettingVettingTypes")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "personvettings/{personsVettingID}/vettingtypes")]HttpRequestMessage request, long personsVettingID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    IGetPersonVettingVettingTypes_Result result = null;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Initialize Vetting Service
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);

                        try
                        {
                            result = vettingService.GetPersonsVettingVettingTypes(personsVettingID);

                            // Return the result
                            return request.CreateResponse(HttpStatusCode.OK, result);
                        }
                        catch (ArgumentException argex) // ArgumentException is the user's fault.  
                                                        // Let other exceptions bubble up to be Internal Server Error.
                        {
                            return request.CreateErrorResponse(HttpStatusCode.BadRequest, argex);
                        }
                    }
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
        }
    }
}
