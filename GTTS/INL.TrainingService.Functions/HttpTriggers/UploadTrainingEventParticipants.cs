using System;
using System.Threading.Tasks;
using System.IO;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Web.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using INL.UserService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
	public static class UploadTrainingEventParticipants
    {
        [FunctionName("UploadTrainingEventParticipants")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "trainingevents/{trainingEventID}/uploadparticipants")]HttpRequestMessage request, int trainingEventID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Read multipart/form-data request
					var provider = new MultipartMemoryStreamProvider();
                    await request.Content.ReadAsMultipartAsync(provider);

                    // Get document stream
                    if (provider.Contents.Count <= 0)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }

                    byte[] fileContent = null;
                    SaveTrainingEventParticipantsXLSX_Param saveTrainingEventParticipantsXLSXParam = null;
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
                                saveTrainingEventParticipantsXLSXParam = JsonConvert.DeserializeObject<SaveTrainingEventParticipantsXLSX_Param>(attachDocumentParamAsJSON);
                                break;
                            default:
                                break;
                        }
                    }

                    if (fileContent == null || fileContent.Length <= 0 || saveTrainingEventParticipantsXLSXParam == null)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }

                    saveTrainingEventParticipantsXLSXParam.ParticipantsExcelStream = new MemoryStream(fileContent);
                    
                    // Validate input
                    if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    if (trainingEventID != saveTrainingEventParticipantsXLSXParam.TrainingEventID)
					{
						throw new ArgumentException();
					}

                    // Upload the training event participants XLXS
                    ISaveTrainingEventParticipantsXLSX_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveTrainingEventParticipantsXLSXParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

						// Call the TrainingService
						result = trainingService.SaveTrainingEventParticipantsXLSX(saveTrainingEventParticipantsXLSXParam);
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
