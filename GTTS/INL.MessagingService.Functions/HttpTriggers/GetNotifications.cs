using INL.Functions;
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
    public static class GetNotifications
    {
        [FunctionName("GetNotifications")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "notifications")]HttpRequestMessage request,
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

                    // Get input
                    var filter = request.GetQueryParametersAsObject<GetNotificationsFilter>();

                    IGetNotifications_Result result;
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var messagingRepository = new MessagingRepository(sqlConnection);
                        var messagingService = new MessagingService(messagingRepository);

                        // Determine processing path
                        if (filter.AppUserID.HasValue)
                        {
                            // Get all user's notifications with filtering
                            result = messagingService.GetNotificationsByAppUserIDPaged(filter.AppUserID.Value, filter.ContextID, 
                                filter.ContextTypeID, filter.PageSize, filter.PageNumber, filter.SortOrder, filter.SortDirection);
                        }
                        else
                        {
                            // Gets all notifications for a specific context ID
                            result = messagingService.GetNotificationsByContextTypeAndContextID(filter.ContextTypeID.Value, filter.ContextID.Value);
                        }
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

    class GetNotificationsFilter
    {
        public int? AppUserID { get; set; }
        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
        public int? ContextTypeID { get; set; }
        public long? ContextID { get; set; }
        public string SortOrder { get; set; }
        public string SortDirection { get; set; }
    }
}
