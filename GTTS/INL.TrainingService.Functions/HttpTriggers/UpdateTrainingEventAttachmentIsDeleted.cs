using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using INL.DocumentService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class UpdateTrainingEventAttachmentIsDeleted
    {
        [FunctionName("UpdateTrainingEventAttachmentIsDeleted")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/attachments/{attachmentID}/isdeleted")]HttpRequestMessage request,
            long trainingEventID,
            long attachmentID,
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

                    // Read input
                    var updateTrainingEventParticipantIsDeletedParam = await request.Content.ReadAsAsyncCustom<IUpdateTrainingEventAttachmentIsDeleted_Param>(new TrainingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (trainingEventID == 0 || attachmentID == 0)
                    {
                        throw new IndexOutOfRangeException();
                    }

                    if (trainingEventID != updateTrainingEventParticipantIsDeletedParam.TrainingEventID
                        || attachmentID != updateTrainingEventParticipantIsDeletedParam.AttachmentID)
                    {
                        throw new ArgumentException();
                    }


                    // Attach the document to the training event participant
                    GetTrainingEventAttachment_Result softDeleteParticipantAttachmentResult = null;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();

                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository, log);

                        softDeleteParticipantAttachmentResult = trainingService.UpdateTrainingEventAttachmentIsDeleted(
                            updateTrainingEventParticipantIsDeletedParam, documentServiceClient, myUserProfile.UserProfileItem.AppUserID);
                    }

                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK, softDeleteParticipantAttachmentResult);
                }
                catch (Exception ex)
                {
                    return helper.CreateErrorResponse(ex);
                }
            }
        }
    }
}
