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
    public static class AttachDocumentToTrainingEventParticipant
    {
        [FunctionName("AttachDocumentToTrainingEventParticipant")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents/{trainingEventID}/participants/{personID}/attachments")]HttpRequestMessage request,
            long trainingEventID,
            long personID,
            ILogger log,
            ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Check if this is a multipart/form-data POST
                if (!request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                }

                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    // Read multipart/form-data request
                    var provider = new MultipartMemoryStreamProvider();
                    await request.Content.ReadAsMultipartAsync(provider);

                    // Get document stream, there should be only one
                    if (provider.Contents.Count <= 0)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }

                    byte[] fileContent = null;
                    AttachDocumentToTrainingEventParticipant_Param attachDocumentParam = null;
                    foreach (var content in provider.Contents)
                    {
                        string name = content.Headers.ContentDisposition.Name.Trim('\"');

                        switch (name)
                        {
                            case "file":
                                fileContent = await content.ReadAsByteArrayAsync();
                                break;
                            case "params":
                                var attachDocumentParamAsJSON = await content.ReadAsStringAsync();
                                attachDocumentParam = JsonConvert.DeserializeObject<AttachDocumentToTrainingEventParticipant_Param>(attachDocumentParamAsJSON);
                                break;
                            default:
                                break;
                        }
                    }

                    if (fileContent == null || fileContent.Length <= 0 || attachDocumentParam == null)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }

                    attachDocumentParam.TrainingEventParticipantAttachmentTypeID = 1; // TODO:  Remove this when attachmenttypes is implemented


                    // Attach the document to the training event participant
                    AttachDocumentToTrainingEventParticipant_Result attachDocumentResult = null;
					using (var userService = await helper.GetUserServiceClientAsync())
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						attachDocumentParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository, log);

                        // (TODO) Handle rollback when inserting a record to training.TrainingEventStudentAttachments failed, need to roll back Files table and BLOB resource.
                        attachDocumentResult = await trainingService.AttachDocumentToTrainingEventParticipantAsync(attachDocumentParam, fileContent, documentServiceClient);
                    }

                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK, attachDocumentResult);
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}

        }
    }
}
