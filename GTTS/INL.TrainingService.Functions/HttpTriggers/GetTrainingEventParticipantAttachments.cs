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
using System.Threading.Tasks;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventParticipantAttachments
    {
        [FunctionName("GetTrainingEventParticipantAttachments")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/participants/{personID}/attachments")]HttpRequestMessage request,
            long trainingEventID,
            long personID,
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

                    string participantType = string.Empty;
                    var p = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key == "participantType");
                    if (!string.IsNullOrWhiteSpace(p.Value))
                        participantType = p.Value;
                    else
                        return request.CreateErrorResponse(HttpStatusCode.BadRequest, "Participant type required");

                    // Create parameter for service
                    var getTrainingEventParticipantAttachmentsParam = new GetTrainingEventParticipantAttachments_Param()
                    {
                        TrainingEventID = trainingEventID,
                        PersonID = personID,
                        ParticipantType = participantType
                    };


                    // Fetch the training event participant attachments
                    GetTrainingEventParticipantAttachments_Result attachments = null;
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository, log);

                        try
                        {
                            attachments = await trainingService.GetTrainingEventParticipantAttachmentsAsync(getTrainingEventParticipantAttachmentsParam, documentServiceClient);
                        }
                        catch (ArgumentException argex) // ArgumentException is the user's fault.  
                                                        // Let other exceptions bubble up to be Internal Server Error.
                        {
                            return request.CreateErrorResponse(HttpStatusCode.BadRequest, argex);
                        }
                    }


                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK, attachments);
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
        }
    }
}
