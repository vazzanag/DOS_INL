using INL.MessagingService.Data;
using INL.MessagingService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace INL.MessagingService.Functions.HttpTriggers
{
    public static class GetNotificationAppRoleContext
    {
        [FunctionName("GetNotificationAppRoleContext")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "notifications/{notificationID:long}/{appRole}/approlecontexts")]HttpRequestMessage request,
            long notificationID,
            string appRole,
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

                    IGetNotificationAppRoleContext_Result result;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var messagingRepository = new MessagingRepository(sqlConnection);
                        var messagingService = new MessagingService(messagingRepository);

                        // Determine processing path
                        result = messagingService.GetNotificationAppRoleContextByNotificationIDAndAppRole(notificationID, appRole);
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
