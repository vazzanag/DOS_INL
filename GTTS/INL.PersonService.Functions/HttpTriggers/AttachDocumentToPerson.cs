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
    public static class AttachDocumentToPerson
    {
        [FunctionName("AttachDocumentToPerson")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "persons/{personID}/attachments")]HttpRequestMessage request, 
            long personID, 
            ILogger log, 
            ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Check if this is a multipart/form-data POST
                if (!request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                }

                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);

                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();

                    // Read multipart/form-data request
                    var provider = new MultipartMemoryStreamProvider();
                    await request.Content.ReadAsMultipartAsync(provider);

                    // Get document stream, there should be only one
                    if (provider.Contents.Count <= 0)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }

                    byte[] fileContent = null;
                    SavePersonAttachment_Param attachDocumentParam = null;
                    foreach (var content in provider.Contents)
                    {
                        string name = content.Headers.ContentDisposition.Name.Trim('\"');

                        switch (name)
                        {
                            case "file":
                                fileContent = await content.ReadAsByteArrayAsync();
                                break;
                            case "params":
                                var attachDocumentParamAsJSON = await content.ReadAsStringAsync();
                                attachDocumentParam = JsonConvert.DeserializeObject<SavePersonAttachment_Param>(attachDocumentParamAsJSON);
                                break;
                            default:
                                break;
                        }
                    }

                    if (fileContent == null || fileContent.Length <= 0 || attachDocumentParam == null)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }


                    // Fetch persons data with unit info
                    ISavePersonAttachment_Result result = null;
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();
                        attachDocumentParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

                        var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

                        result = await personService.AttachDocumentToPerson(attachDocumentParam, fileContent, documentServiceClient);
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
