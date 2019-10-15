using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Collections.Generic;
using INL.Functions;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using INL.ReferenceService.Client;
using INL.PersonService.Client;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Security.Authentication;
using INL.MessagingService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class SaveTrainingEventStudentRoster
    {
        [FunctionName("SaveTrainingEventStudentRoster")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", "post", Route = "trainingevents/{trainingEventID}/rosters")]HttpRequestMessage request, long trainingEventID, ILogger log, ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Validate input
					if (trainingEventID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    // Create objects for storing request data
                    ISaveTrainingEventRoster_Param saveTrainingEventStudentRoster = null;
                    byte[] fileContent = null;

                    // Check if a file was included in request
                    //if (request.Content.Headers.ContentType.MediaType == "multipart/form-data")
                    if (request.Content.IsMimeMultipartContent())
                    {
                        // Read multipart/form-data request
                        var provider = new MultipartMemoryStreamProvider();

                        // File attached, get content
                        await request.Content.ReadAsMultipartAsync(provider);

                        // Get document stream
                        if (provider.Contents.Count <= 0)
                        {
							throw new ArgumentException();
                        }

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
                                    saveTrainingEventStudentRoster = JsonConvert.DeserializeObject<SaveTrainingEventRoster_Param>(attachDocumentParamAsJSON);
                                    break;
                                default:
                                    break;
                            }
                        }

                        if ((fileContent == null || fileContent.Length <= 0) && saveTrainingEventStudentRoster.Participants.Count == 0)
						{
							throw new ArgumentException();
						}

                        // Add Stream to parameter
                        saveTrainingEventStudentRoster.StudentExcelStream = new System.IO.MemoryStream(fileContent);
                    }
                    else
                    {
                        // No file attached, read input
                        saveTrainingEventStudentRoster = await request.Content.ReadAsAsyncCustom<ISaveTrainingEventRoster_Param>(new TrainingServiceJsonConvertor().JsonConverters);
                    }
                    
                    // Integrity check
                    if (trainingEventID != saveTrainingEventStudentRoster.TrainingEventID)
						throw new ArgumentException();

					// Validate there there is data to be saved
					if ((fileContent == null || fileContent.Length <= 0) && saveTrainingEventStudentRoster.Participants.Count == 0)
						throw new ArgumentException();

					// Save the training event
					ISaveTrainingEventRoster_Result result = new SaveTrainingEventRoster_Result();
                    using (var vettingService = await helper.GetVettingServiceClientAsync())
                    using (var userService = await helper.GetUserServiceClientAsync())
					using (var referenceServiceClient = await helper.GetReferenceServiceClientAsync())
                    using (var personServiceClient = await helper.GetPersonServiceClientAsync())
                    using (var messagingServiceClient = await helper.GetMessagingServiceClientAsync())
                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
                        var myUserProfile = await userService.GetMyProfile();
                        saveTrainingEventStudentRoster.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

                        // Instantiate TrainingService
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        // Call TrainingService
                        result = trainingService.SaveStudentRoster(saveTrainingEventStudentRoster, personServiceClient, referenceServiceClient, messagingServiceClient, vettingService);
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
