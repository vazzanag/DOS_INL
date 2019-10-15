using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace INL.VettingService.Functions.HttpTriggers
{
    public static class GetCourtesyFile
    {
        private static Configuration configuration;

        [FunctionName("GetCourtesyFile")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "batches/{vettingBatchID}/courtesy")]HttpRequestMessage request, long vettingBatchID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Fetch courtesy Vetting Batch
					IGetCourtesyFile_Result result = null;
                    using (var trainingServiceClient = await helper.GetTrainingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

                        result = vettingService.GetCourtesyFile(vettingBatchID, context.FunctionAppDirectory, trainingServiceClient);
					}

					//return attachment
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
