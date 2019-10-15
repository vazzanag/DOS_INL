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
using System.Security.Authentication;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace INL.VettingService.Functions.HttpTriggers
{
    public class GetInvestVettingBatchByVettingBatchID
    {
        [FunctionName("GetInvestVettingBatchByVettingBatchID")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "batches/{vettingBatchID}/invest")]HttpRequestMessage request, long vettingBatchID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Fetch Invest Vetting Batch
					IGetInvestVettingBatch_Result result = null;
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();

                        // Instantiate VettingService
                        var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);

						// Call VettingService
						result = vettingService.GetInvestVettingBatchByVettingBatchID(vettingBatchID, context.FunctionAppDirectory, trainingServiceClient, myUserProfile.UserProfileItem.AppUserID);
					}

					// Return the result
					var response = request.CreateResponse(HttpStatusCode.OK);
					response.Content = new ByteArrayContent(result.FileContent);
					response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
					response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
					{
						FileName = result.FileName
					};

					return response;
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
		}
	}
}

