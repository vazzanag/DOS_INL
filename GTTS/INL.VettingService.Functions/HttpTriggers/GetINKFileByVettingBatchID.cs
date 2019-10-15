using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Authentication;
using System.Threading.Tasks;

namespace INL.VettingService.Functions.HttpTriggers
{
	public class GetINKFileByVettingBatchID
	{
		[FunctionName("GetINKFileByVettingBatchID")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "batches/{vettingBatchID}/ink")]HttpRequestMessage request, long vettingBatchID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Fetch CSV String
					IINKFile_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate VettingService
						var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);

						// Call VettingService
						result = vettingService.GetINKFileByVettingBatchID(vettingBatchID);
					}

					// return attachment
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
