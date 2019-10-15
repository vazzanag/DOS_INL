using System;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Linq;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.DocumentService.Data;
using INL.DocumentService.Models;


namespace INL.DocumentService.Functions.HttpTriggers
{
    public static class GetDocumentInfo
	{
		[FunctionName("GetDocumentInfo")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "documents/{fileID:long}/info")]HttpRequestMessage request, long fileID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Get file version parameter
					int? fileVersion = null;
					try
					{
						var fileVersionString = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key.ToLower() == "v").Value;
						int tryParseFileVersion;
						Int32.TryParse(fileVersionString, out tryParseFileVersion);
						if (tryParseFileVersion > 0) fileVersion = tryParseFileVersion;
					}
					catch (Exception ex)
					{
						throw new ArgumentException("Errors occurred while obtaining query string values", ex);
					}

					// Fetch the document
					GetDocumentInfo_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate DocumentService
						var documentRepository = new DocumentRepository(sqlConnection);
						DocumentService documentService = new DocumentService(documentRepository);

						// Call the DocumentService
						result = await documentService.GetDocumentInfoAsync(
								new GetDocumentInfo_Param() {
									FileID = fileID,
									FileVersion = fileVersion
								}
							);
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
