using System;
using System.Net;
using System.Net.Http;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Security.Claims;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;

using INL.Functions;
using INL.UnitLibraryService.Models;
using INL.UnitLibraryService.Data;
using System.Net.Http.Headers;

namespace INL.UnitLibraryService.Functions.HttpTriggers
{
    public static class GetUnitLibraryPDF
    {
        [FunctionName("GetUnitLibraryPDF")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "units/{unitID}/pdf")]HttpRequestMessage request, long unitID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();


                    byte[] result = null;

                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var myUserProfile = await userService.GetMyProfile();

                        var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository);

                        result = unitLibraryService.GeneratePDF(unitID, myUserProfile.UserProfileItem.FullName);
                    }

                    var response = request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new ByteArrayContent(result);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                    {
                        FileName = "UnitLibrary.pdf"
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
