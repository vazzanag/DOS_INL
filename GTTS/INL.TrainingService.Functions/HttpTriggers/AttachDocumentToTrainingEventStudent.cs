using INL.DocumentService.Client;
using INL.Functions;
using INL.UserService.Client;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;


namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class AttachDocumentToTrainingEventStudent
    {
        [FunctionName("AttachDocumentToTrainingEventStudent")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents/{trainingEventID}/students/{personID}/attachments")]HttpRequestMessage request,
            long trainingEventID,
            long personID,
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

					// Get parameter
					byte[] fileContent = null;
					var attachDocumentParam = request.Content.ReadAsMultipartAsyncCustom<AttachDocumentToTrainingEventStudent_Param>(out fileContent, new TrainingServiceJsonConvertor().JsonConverters);
					if (attachDocumentParam == null)
					{
						throw new ArgumentException();
					}
					else if (fileContent == null || fileContent.Length <= 0)
					{
						throw new ArgumentException("NO FILE");
					}					
                    attachDocumentParam.TrainingEventStudentAttachmentTypeID = 1; // TODO:  Remove this when attachmenttypes is implemented
					
                    // Attach the document to the training event student
                    AttachDocumentToTrainingEventStudent_Result attachDocumentResult;
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
						// (TODO) Handle rollback when inserting a record to training.TrainingEventStudentAttachments failed, need to roll back Files table and BLOB resource.
						attachDocumentResult = await trainingService.AttachDocumentToTrainingEventStudentAsync(attachDocumentParam, fileContent, documentServiceClient);
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
