using INL.Functions;
using INL.MessagingService.Data;
using INL.MessagingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;


namespace INL.MessagingService.Functions.HttpTriggers.Notifications.Vetting
{
    public static class LeahyBatchRejected
    {
        [FunctionName("LeahyBatchRejected")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "notifications/leahybatchrejected")]HttpRequestMessage request,
            ILogger log,
            ExecutionContext context)
        {
            return request.CreateResponse(HttpStatusCode.BadRequest, "Not implemented");
        }
    }
}
