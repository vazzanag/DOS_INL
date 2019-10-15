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
    public class GetCourtesyBatchesByVettingBatchIDAndVettingTypeID
    {
        [FunctionName("GetCourtesyBatchesByVettingBatchIDAndVettingTypeID")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", 
            Route = "batches/{vettingBatchID}/courtesy/{vettingTypeID}")]HttpRequestMessage request,
            long vettingBatchID, int vettingTypeID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();
                    
                    ICourtesyBatch_Item result = null;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

						// Call VettingService
						result = vettingService.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(vettingBatchID, vettingTypeID);
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

