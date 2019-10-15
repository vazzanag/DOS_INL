using System;
using System.IO;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Security.Claims;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using INL.Functions;
using INL.VettingService.Models;
using INL.VettingService.Data;
using INL.DocumentService.Client;

namespace INL.VettingService.Functions.HttpTriggers
{

    public static class AttachDocumentToVettingHit
    {
        [FunctionName("AttachDocumentToVettingHit")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = "vettinghits/{vettingHitID}/attachments")]HttpRequestMessage request, long vettingHitID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
                    AttachDocumentToVettingHit_Param attachDocumentParam = null;
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
                                attachDocumentParam = JsonConvert.DeserializeObject<AttachDocumentToVettingHit_Param>(attachDocumentParamAsJSON);
                                break;
                            default:
                                break;
                        }
                    }

                    if (fileContent == null || fileContent.Length <= 0 || attachDocumentParam == null)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }

                    
                    // Attach the document to the training event
                    AttachDocumentToVettingHit_Result attachDocumentResult = null;

                    using (var userService = await helper.GetUserServiceClientAsync())
                    using (var documentServiceClient = await helper.GetDocumentServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();

                        var vettingRepository = new VettingRepository(sqlConnection);
                        var vettingService = new VettingService(vettingRepository, log);

                        attachDocumentParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

                        // (TODO) Handle rollback when inserting a record to vetting.VettingHitAttachment failed, need to roll back Files table and BLOB resource.
                        attachDocumentResult = await vettingService.AttachDocumentToVettingHitAsync(attachDocumentParam, fileContent, documentServiceClient);
                    }

                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK, attachDocumentResult);
                }
                catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
            }

        }

    }
}
