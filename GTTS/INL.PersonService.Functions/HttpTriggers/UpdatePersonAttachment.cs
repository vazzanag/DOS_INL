using INL.Functions;
using INL.PersonService.Data;
using INL.PersonService.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using System.Security.Authentication;
using Newtonsoft.Json;

namespace INL.PersonService.Functions.HttpTriggers
{
    public static class UpdatePersonAttachment
    {
        [FunctionName("UpdatePersonAttachment")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "persons/{personID}/attachments/{fileID}")]HttpRequestMessage request,
            long personID, long fileID,
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

                    // Get parameter
                    var updatePersonAttachmentParam = await request.Content.ReadAsAsyncCustom<SavePersonAttachment_Param>(new PersonServiceJsonConvertor().JsonConverters);

                    // Ensure the personID was passed on the URL and matches the id in the payload
                    if (personID == 0 || fileID == 0)
                    {
                        throw new IndexOutOfRangeException();
                    }

                    if (personID != updatePersonAttachmentParam.PersonID || fileID != updatePersonAttachmentParam.FileID)
                    {
                        throw new ArgumentException();
                    }


                    // Fetch persons data with unit info
                    ISavePersonAttachment_Result result = null;
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();
                        updatePersonAttachmentParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

                        var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

                        result = personService.UpdatePersonAttachment(updatePersonAttachmentParam);
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
