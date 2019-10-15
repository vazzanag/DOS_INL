using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class SaveTrainingEventParticipantReturnDate
    {
        [FunctionName("SaveTrainingEventParticipantReturnDate")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "trainingevents/{trainingeventid}/participants/{personid}/returndate")]HttpRequestMessage request, long trainingEventID, long personID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {

            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Init the FunctionHelper
                var helper = new FunctionHelper(request, context, log);
                try
                {
                    // Authorize the user
                    helper.AuthorizeUser();


                    // Read input
                    var saveTrainingEventParticipantValueParam = await request.Content.ReadAsAsyncCustom<ISaveTrainingEventParticipantValue_Param>(new TrainingServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (trainingEventID == 0 || personID == 0)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.NotFound, "");
                    }
                    else
                    {
                        // Ensure the id on the URL matches the id in the payload
                        if ((trainingEventID != saveTrainingEventParticipantValueParam.TrainingEventID)
                            || (personID != saveTrainingEventParticipantValueParam.PersonID))
                        {
                            return request.CreateErrorResponse(HttpStatusCode.BadRequest, "");
                        }
                    }

                    // Save the training event
                    int result = -1;

                    using (var sqlConnection = await helper.GetSqlConnectionAsync())
                    {
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        try
                        {
                            result = trainingService.SaveTrainingEventParticipantValue(saveTrainingEventParticipantValueParam);

                            if (result < 1)
                                return request.CreateErrorResponse(HttpStatusCode.InternalServerError, new Exception("No records updated"));
                            else if (result > 1)
                                return request.CreateErrorResponse(HttpStatusCode.InternalServerError, new Exception("Multiple updated"));
                        }
                        catch (ArgumentException argex) // ArgumentException is the user's fault.  
                                                        // Let other exceptions bubble up to be Internal Server Error.
                        {
                            return request.CreateErrorResponse(HttpStatusCode.BadRequest, argex);
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
}
