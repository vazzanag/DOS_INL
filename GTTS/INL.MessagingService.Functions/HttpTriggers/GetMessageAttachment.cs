using INL.DocumentService.Client.Models;
using INL.MessagingService.Functions;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Authentication;
using System.Threading.Tasks;

namespace INL.TrainingService.Functions.HttpTriggers
{
	public static class GetMessageAttachment
	{
		[FunctionName("GetMessageAttachment")]
		public static async Task<HttpResponseMessage> Run(
			[HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "messageattachments/{attachmentID}")]HttpRequestMessage request,
			long attachmentID,
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

					GetDocument_Result result;
					using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						GetDocument_Param param = new GetDocument_Param();
						param.FileID = attachmentID;
						param.FileVersion = fileVersion;
						result = await documentServiceClient.GetDocumentAsync(param);
					}

					// Return the result
					var response = request.CreateResponse(HttpStatusCode.OK);
					response.Content = new ByteArrayContent(result.FileContent);
					response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
					response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
					{
						FileName = result.FileName
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
