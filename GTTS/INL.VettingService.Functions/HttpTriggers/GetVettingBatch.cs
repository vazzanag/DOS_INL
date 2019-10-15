using System;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Security.Claims;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Mapster;
using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using System.Security.Authentication;

namespace INL.VettingService.Functions.HttpTriggers
{
    public class GetVettingBatch
    {
        [FunctionName("GetVettingBatch")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "batches/{vettingBatchID}")]HttpRequestMessage request, long vettingBatchID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

                    int? vettingTypeID = null;
                    var type = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key == "vettingTypeID");
                    if (!string.IsNullOrWhiteSpace(type.Value))
                    {
                        int tryParseVettingTypeID;
                        int.TryParse(type.Value, out tryParseVettingTypeID);
                        if (tryParseVettingTypeID > 0) vettingTypeID = tryParseVettingTypeID;
                    }

                    // Fetch the vetting batch
                    IGetVettingBatch_Result result = null;
                    using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

						// Call VettingService
						result = vettingService.GetVettingBatch(vettingBatchID, vettingTypeID, trainingServiceClient);
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

