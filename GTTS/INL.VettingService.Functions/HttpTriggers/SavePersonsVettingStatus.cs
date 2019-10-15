using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.VettingService.Models;
using INL.VettingService.Data;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class SavePersonsVettingStatus
    {

        [FunctionName("SavePersonsVettingStatus")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "personvettings/{personvettingid}/vettingstatus")]HttpRequestMessage request, long personVettingID, ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    // Read input
                    var associateParam = await request.Content.ReadAsAsyncCustom<SavePersonsVettingStatus_Param>(new VettingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (personVettingID == 0)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.NotFound, "");
                    }
                    else
                    {
                        // Ensure the id on the URL matches the id in the payload
                        if (personVettingID != associateParam.PersonsVettingID)
                        {
                            return request.CreateErrorResponse(HttpStatusCode.BadRequest, "");
                        }
                    }

                    // Save the person vetting vetting type  event
                    IPersonVetting_Item result = null;

                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();

                        associateParam.ModifiedAppUserID = myUserProfile.UserProfileItem.AppUserID;

                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);

                        try
                        {
                            result = vettingService.SavePersonsVettingStatus(associateParam);
                        }
                        catch (ArgumentException argex) // ArgumentException is the user's fault.  
                                                        // Let other exceptions bubble up to be Internal Server Error.
                        {
                            return request.CreateErrorResponse(HttpStatusCode.BadRequest, argex);
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
