using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using INL.DocumentService.Client;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class GetLeahyResultFile
    {

        [FunctionName("GetLeahyResultFile")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "batches/{vettingBatchID}/files/{fileID}/investresult")]HttpRequestMessage request, long vettingBatchID, long fileID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    int? fileVersion = null;
                    var v = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key == "v");
                    if (!string.IsNullOrWhiteSpace(v.Value))
                    {
                        int tryParseFileVersion;
                        int.TryParse(v.Value, out tryParseFileVersion);
                        if (tryParseFileVersion > 0) fileVersion = tryParseFileVersion;
                    }

                    // Fetch Invest Vetting Batch
                    IBaseFileAttachment_Result result = null;

                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

                        // (TODO) Handle rollback when inserting a record to training.TrainingEventAttachments failed, need to roll back Files table and BLOB resource.
                        result = await vettingService.GetLeahyResultFile(fileID, fileVersion, documentServiceClient);
                    }
                    // Return the result
                    var response = request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new ByteArrayContent(result.files[0].FileContent);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                    {
                        FileName = result.files[0].FileName
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