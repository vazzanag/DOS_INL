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
using INL.DocumentService.Data;
using INL.DocumentService.Models;


namespace INL.DocumentService.Functions.HttpTriggers
{
	public static class SaveDocument
	{
		[FunctionName("SaveDocument")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "documents")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveDocumentParam = request.Content.ReadAsMultipartAsyncCustom<SaveDocument_Param>(out fileContent, new DocumentServiceJsonConverter().JsonConverters);
					if (saveDocumentParam == null)
					{
						throw new ArgumentException();
					}
					else if (fileContent == null || fileContent.Length <= 0)
					{
						throw new ArgumentException("NO FILE");
					}
					saveDocumentParam.FileContent = fileContent;

					// Save the file to Blob storage and write metadata to the database
					SaveDocument_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile(); 
						saveDocumentParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate DocumentService
						var documentRepository = new DocumentRepository(sqlConnection);
						var blobRepository = new BlobRepository(helper.Configuration.INLDocumentServiceBlobStorageConnectionString, log);
						DocumentService documentService = new DocumentService(documentRepository, blobRepository, log);

						// Call the DocumentService
						result = await documentService.SaveDocumentAsync(saveDocumentParam);
					}

                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK, result);
                }
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
		}
	}
}
