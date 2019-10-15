using System;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.UserService.Client;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using INL.DocumentService.Client;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class AttachDocumentToTrainingEvent
	{
		[FunctionName("AttachDocumentToTrainingEvent")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents/{trainingEventID}/attachments")]HttpRequestMessage request, long trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Get parameter
					byte[] fileContent = null;
					var attachDocumentParam = request.Content.ReadAsMultipartAsyncCustom<AttachDocumentToTrainingEvent_Param>(out fileContent, new TrainingServiceJsonConvertor().JsonConverters);
					if (attachDocumentParam == null)
					{
						throw new ArgumentException();
					}
					else if (fileContent == null || fileContent.Length <= 0)
					{
						throw new ArgumentException("NO FILE");
					}
					
					attachDocumentParam.TrainingEventAttachmentTypeID = 1; // TODO:  Remove this when attachmenttypes is implemented


                    // Attach the document to the training event
                    AttachDocumentToTrainingEvent_Result attachDocumentResult;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						attachDocumentParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
						var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						// (TODO) Handle rollback when inserting a record to training.TrainingEventAttachments failed, need to roll back Files table and BLOB resource.
						attachDocumentResult = await trainingService.AttachDocumentToTrainingEventAsync(attachDocumentParam, fileContent, documentServiceClient);
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

