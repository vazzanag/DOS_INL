using INL.Functions;
using INL.MessagingService;
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
    public static class UpdateNotificationRecipientDateViewed
    {
        [FunctionName("UpdateNotificationRecipientDateViewed")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "notifications/{notificationID}/recipients/{appUserID}/DateViewed")]HttpRequestMessage request,
            long notificationID, int appUserID,
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

                    var updateNotificationRecipientDateViewedParam = await request.Content.ReadAsAsyncCustom<UpdateNotificationDateViewed_Param>(new MessagingServiceJsonConverter().JsonConverters);

                    // Ensure the id on the URL matches the id in the payload
                    if (notificationID != updateNotificationRecipientDateViewedParam.NotificationID
                        && appUserID != updateNotificationRecipientDateViewedParam.AppUserID)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.BadRequest, "");
                    }

                    IGetNotificationRecipient_Result result;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Setup LocationClientService
                        var messagingRepository = new MessagingRepository(sqlConnection);
                        var messagingService = new MessagingService(messagingRepository);

                        result = messagingService.UpdateDateViewed(updateNotificationRecipientDateViewedParam);
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
