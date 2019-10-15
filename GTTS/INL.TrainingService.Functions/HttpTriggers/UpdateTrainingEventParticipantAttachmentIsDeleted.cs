using INL.DocumentService.Client;
using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class UpdateTrainingEventParticipantAttachmentIsDeleted
    {
        [FunctionName("UpdateTrainingEventParticipantAttachmentIsDeleted")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingEventID}/participants/{personID}/attachments/{attachmentID}/isdeleted")]HttpRequestMessage request, 
            long trainingEventID,
            long personID,
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
                    var updateTrainingEventParticipantIsDeletedParam = await request.Content.ReadAsAsyncCustom<IUpdateTrainingEventParticipantAttachmentIsDeleted_Param>(new TrainingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (trainingEventID == 0 || personID == 0 || attachmentID == 0)
                    {
                        throw new IndexOutOfRangeException();
                    }

                    if (trainingEventID != updateTrainingEventParticipantIsDeletedParam.TrainingEventID
                        || personID != updateTrainingEventParticipantIsDeletedParam.PersonID
                        || attachmentID != updateTrainingEventParticipantIsDeletedParam.AttachmentID)
                    {
                        throw new ArgumentException();
                    }


                    // Attach the document to the training event participant
                    GetTrainingEventParticipantAttachment_Result softDeleteParticipantAttachmentResult = null;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();

                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository, log);

                        softDeleteParticipantAttachmentResult = trainingService.UpdateTrainingEventParticipantAttachmentIsDeleted(updateTrainingEventParticipantIsDeletedParam, documentServiceClient, myUserProfile.UserProfileItem.AppUserID);
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
