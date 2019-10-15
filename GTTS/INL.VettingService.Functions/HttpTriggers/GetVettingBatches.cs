using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using System.Security.Claims;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Mapster;
using System.Security.Authentication;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class GetVettingBatches
    {

        [FunctionName("GetVettingBatches")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "batches")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            string vettingListParameter = string.Empty;
            string courtesyType = string.Empty;

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


                    // Read input
                    var getVettingBatchesByIdsParam = request.GetQueryParametersAsObject<GetVettingBatchesByIDs_Param>();
                    vettingListParameter = getVettingBatchesByIdsParam.vettingList;
                    courtesyType = getVettingBatchesByIdsParam.courtesyType;

                    // Create array for sending to service
                    long[] vettingList = Array.ConvertAll(vettingListParameter.Split(','), long.Parse);


                    // Fetch vetting List
                    IGetVettingBatches_Result result = null;
                    using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

                        result = vettingService.GetVettingBatchesByIds(vettingList, courtesyType, getVettingBatchesByIdsParam.courtesyStatus, trainingServiceClient);
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
