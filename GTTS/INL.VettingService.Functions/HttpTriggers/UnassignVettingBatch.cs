using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Security.Authentication;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using INL.UserService.Client;

namespace INL.VettingService.Functions.HttpTriggers
{
    public class UnassignVettingBatch
    {
        [FunctionName("UnassignVettingBatch")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "batches/{vettingBatchID}/assignee")]HttpRequestMessage request,
            long vettingBatchID,
            ILogger log,
            ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Unassign Vetting Batch
					IUnassignVettingBatch_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Create parameter
						var unassignVettingBatchParam = new UnassignVettingBatch_Param()
						{
							VettingBatchID = vettingBatchID
						};

						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						unassignVettingBatchParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate VettingService
						var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);

						// Call the VettingService
						result = vettingService.UnassignVettingBatch(unassignVettingBatchParam);
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

