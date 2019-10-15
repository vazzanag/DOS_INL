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
using System.Security.Authentication;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class SavePersonsVettingVettingType
    {
        [FunctionName("SavePersonsVettingVettingType")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "personvetting/{personvettingid}/vettingtypes")]HttpRequestMessage request, long personVettingID, ILogger log, ExecutionContext context)
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
					var savePersonVettingVettingTypeParam = await request.Content.ReadAsAsyncCustom<SavePersonVettingVettingType_Param>(new VettingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (personVettingID == 0)
					{
						throw new IndexOutOfRangeException();
					}
                    else
                    {
                        // Ensure the id on the URL matches the id in the payload
                        if (personVettingID != savePersonVettingVettingTypeParam.PersonVettingID)
						{
							throw new ArgumentException();
						}
                    }

                    // Save the person vetting vetting type  event
                    ISavePersonVettingVettingType_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						savePersonVettingVettingTypeParam.ModifiedAppUserID = myUserProfile.UserProfileItem.AppUserID;

						var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);

                        result = vettingService.SavePersonVettingVettingType(savePersonVettingVettingTypeParam);
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

