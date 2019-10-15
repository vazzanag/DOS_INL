using System;
using System.Net;
using System.Data.SqlClient;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.VettingService.Models;
using INL.VettingService.Data;


namespace INL.VettingService.Functions
{
    public static class GetPostVettingConfiguration
    {
        [FunctionName("GetPostVettingConfiguration")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "Posts/{postID}/PostConfiguration")]HttpRequestMessage request, int postID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Fetch the training event
					IGetPostVettingConfiguration_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);

                        result = vettingService.GetPostVettingConfiguration(postID);

                        if (null == result)
                             throw new IndexOutOfRangeException("Vetting Configuration not found for this post.");
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

