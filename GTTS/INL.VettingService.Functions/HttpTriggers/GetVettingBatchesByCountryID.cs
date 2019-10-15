using INL.Functions;
using INL.TrainingService.Client;
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

namespace INL.VettingService.Functions.HttpTriggers
{
    public class GetVettingBatchesByCountryID
    {
        [FunctionName("GetVettingBatchesByCountryID")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get",
            Route = "countries/{countryID}/batches")]HttpRequestMessage request,
            int countryID,
            ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Set up parameter
					var getVettingBatchesByCountryIDParam = request.GetQueryParametersAsObject<GetVettingBatchesByCountryID_Param>();
					getVettingBatchesByCountryIDParam.CountryID = countryID;

					// Fetch the training event batches
					IGetVettingBatches_Result result = null;
                    using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

						// Call VettingService
						result = vettingService.GetVettingBatchesByCountryID(getVettingBatchesByCountryIDParam, trainingServiceClient);
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

