using INL.DocumentService.Client;
using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
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
using System.Security.Authentication;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventStudentAttachment
    {
        [FunctionName("GetTrainingEventStudentAttachment")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/students/{personID}/attachments/{trainingEventStudentAttachmentID}")]HttpRequestMessage request,
            long trainingEventID,
            long personID,
            long trainingEventStudentAttachmentID,
            ILogger log,
            Microsoft.Azure.WebJobs.ExecutionContext context)
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
                    if (!string.IsNullOrWhiteSpace(v.Value))
                    {
                        int tryParseFileVersion;
                        int.TryParse(v.Value, out tryParseFileVersion);
                        if (tryParseFileVersion > 0) fileVersion = tryParseFileVersion;
                    }

                    // Fetch the training event attachments
                    GetTrainingEventStudentAttachment_Result attachment = null;
					using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        attachment = await trainingService.GetTrainingEventStudentAttachmentAsync(trainingEventStudentAttachmentID, fileVersion, documentServiceClient);
                    }

                    // Return the result
                    var response = request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new ByteArrayContent(attachment.FileContent);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                    {
                        FileName = attachment.FileName
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
