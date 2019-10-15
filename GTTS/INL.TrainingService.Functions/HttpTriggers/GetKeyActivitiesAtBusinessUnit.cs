using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using INL.TrainingService.Models;
using INL.TrainingService.Data;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetKeyActivitiesAtBusinessUnit
    {
        [FunctionName("GetKeyActivitiesAtBusinessUnit")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "BusinessUnits/{businessUnitID}/keyactivities")]HttpRequestMessage request,
            int businessUnitID,
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

                    // Fetch the training event
                    IGetKeyActivitiesAtBusinessUnit_Result result = null;

                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = trainingService.GetKeyActivitiesAtBusinessUnit(businessUnitID);
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
