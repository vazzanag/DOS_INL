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

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventParticipantAttachment
    {
        [FunctionName("GetTrainingEventParticipantAttachment")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/participants/{personID}/attachments/{trainingEventParticipantAttachmentID}")]HttpRequestMessage request,
            long trainingEventID,
            long personID,
            long trainingEventParticipantAttachmentID,
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
                    var v = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key == "v");
                    if (!string.IsNullOrWhiteSpace(v.Value))
                    {
                        int tryParseFileVersion;
                        int.TryParse(v.Value, out tryParseFileVersion);
                        if (tryParseFileVersion > 0) fileVersion = tryParseFileVersion;
                    }

                    string participantType = string.Empty;
                    var p = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key == "participantType");
                    if (!string.IsNullOrWhiteSpace(p.Value))
                        participantType = p.Value;
                    else
                        return request.CreateErrorResponse(HttpStatusCode.BadRequest, "Participant type required");

                    // Create parameter for service
                    var getTrainingEventParticipantAttachmentParam = new GetTrainingEventParticipantAttachment_Param()
                    {
                        TrainingEventParticipantAttachmentID = trainingEventParticipantAttachmentID,
                        ParticipantType = participantType,
                        FileVersion = fileVersion
                    };

                    // Fetch the training event participant attachment
                    GetTrainingEventParticipantAttachment_Result attachment = null;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    {

                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository, log);

                        try
                        {
                            attachment = await trainingService.GetTrainingEventParticipantAttachmentAsync(getTrainingEventParticipantAttachmentParam, documentServiceClient);
                        }
                        catch (ArgumentException argex) // ArgumentException is the user's fault.  
                                                        // Let other exceptions bubble up to be Internal Server Error.
                        {
                            return request.CreateErrorResponse(HttpStatusCode.BadRequest, argex);
                        }
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
