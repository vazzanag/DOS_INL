using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace INL.VettingService.Functions.HttpTriggers
{
	public class GetPersonVettingStatuses
    {
        [FunctionName("GetPersonVettingStatuses")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "persons/{personID}/vettingstatus")]HttpRequestMessage request, long personID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

                    // Fetch the vetting status
                    IGetPersonVettingStatuses_Result result = null;

					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository);

                        result = vettingService.GetPersonVettingStatuses(personID);
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

