using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Authentication;
using System.Threading.Tasks;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class ExportTrainingEventParticipants
    {
        [FunctionName("ExportTrainingEventParticipants")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/participantlist")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();


                    // Set File Result
                    IParticipantExport_Result result = null;
                    using (var vettingService = await helper.GetVettingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Instantiate TrainingService
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        // Call TrainingService Method
                        result = trainingService.ExportParticipantList(trainingEventID, vettingService);
                    }

                    // return attachment
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