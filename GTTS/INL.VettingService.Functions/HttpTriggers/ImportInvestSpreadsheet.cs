using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;
using System.Web.Http;
using INL.DocumentService.Client;

namespace INL.VettingService.Functions.HttpTriggers
{
	public static class ImportInvestSpreadsheet
	{
		[FunctionName("ImportInvestSpreadsheet")]
		public static async Task<HttpResponseMessage> Run(
			[HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "batches/{vettingBatchID}/invest")]HttpRequestMessage request,
			long vettingBatchID,
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

					// Check if this is a multipart/form-data POST
					if (!request.Content.IsMimeMultipartContent())
					{
						throw new ArgumentException("No file included in request.");
					}

					// Read multipart/form-data request
					var provider = new MultipartMemoryStreamProvider();
					await request.Content.ReadAsMultipartAsync(provider);

					// Get document stream and other form data
					if (provider.Contents.Count <= 0)
					{
						throw new ArgumentException("No file included in request.");
					}

                    byte[] fileContent = null;
                    AttachImportInvest_Param attachDocumentParam = null;
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
                                attachDocumentParam = JsonConvert.DeserializeObject<AttachImportInvest_Param>(attachDocumentParamAsJSON);
                                break;
                            default:
                                break;
                        }
                    }

                    if (fileContent == null || fileContent.Length <= 0)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.BadRequest, "No file included in request.");
                    }
                    ImportInvestFileResult result;



                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();
                        attachDocumentParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
                        var vettingRepository = new VettingRepository(sqlConnection);
                        VettingService vettingService = new VettingService(vettingRepository, log);

                        result = await vettingService.ImportInvestVettingBatchSpreadsheet(attachDocumentParam, fileContent, documentServiceClient, trainingServiceClient);
                    }


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
