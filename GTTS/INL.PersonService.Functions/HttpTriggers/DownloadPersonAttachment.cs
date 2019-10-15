using INL.Functions;
using INL.PersonService.Data;
using INL.PersonService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Security.Authentication;

namespace INL.PersonService.Functions.HttpTriggers
{
    public static class DownloadPersonAttachment
    {
        [FunctionName("DownloadPersonAttachment")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "persons/{personID}/attachments/{fileID}/download")]HttpRequestMessage request,
            long personID, long fileID,
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


                    int? fileVersion = null;
                    var v = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key.ToLower() == "v");
                    if (!String.IsNullOrWhiteSpace(v.Value))
                    {
                        int tryParseFileVersion;
                        int.TryParse(v.Value, out tryParseFileVersion);
                        if (tryParseFileVersion > 0) fileVersion = tryParseFileVersion;
                    }

                    // Fetch the training event attachments
                    GetPersonAttachment_Result attachment = null;
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Instantiate TrainingService
                        var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

                        attachment = await personService.GetTrainingEventAttachmentAsync(personID, fileID, fileVersion, documentServiceClient);
                    }


                    // Return the result
                    var response = request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new ByteArrayContent(attachment.Item.FileContent);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                    {
                        FileName = attachment.Item.FileName
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
