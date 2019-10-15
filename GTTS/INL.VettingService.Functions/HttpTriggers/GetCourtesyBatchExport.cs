using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class GetCourtesyBatchExport
    {
        [FunctionName("GetCourtesyBatchExport")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "batches/{vettingBatchID}/export/{vettingTypeID}")]HttpRequestMessage request,
            long vettingBatchID, int vettingTypeID,  ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    // Fetch courtesy Vetting Batch
                    IGetVettingBatchExport result = null;
                    using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

                        result = vettingService.ExportVettingBatch(vettingBatchID, vettingTypeID, trainingServiceClient);
                    }

                    //return attachment
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
