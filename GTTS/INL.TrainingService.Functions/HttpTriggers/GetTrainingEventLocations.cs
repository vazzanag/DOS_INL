using System;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventLocations
    {
        [FunctionName("GetTrainingEventLocations")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/locations")]HttpRequestMessage request, 
            long trainingEventID, ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();


                    // Fetch the training event participants
                    GetTrainingEventLocations_Result result = null;

                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        result = trainingService.GetTrainingEventLocations(trainingEventID);
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
