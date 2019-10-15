using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Linq;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using INL.TrainingService.Models;
using INL.TrainingService.Data;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public class GetParticipantRemovalReasons
    {
        [FunctionName("GetParticipantRemovalReasons")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "removalreasons")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();


                    // Fetch the training events
                    GetTrainingRemovalReasons_Result result = null;
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Instantiate TrainingService
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        // Call TrainingService
                        result = trainingService.GetParticipantRemovalReasons();
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
