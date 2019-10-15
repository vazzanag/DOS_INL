using System;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Security.Claims;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using System.Security.Authentication;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventStudent
    {
        [FunctionName("GetTrainingEventStudent")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/students/{trainingEventStudentID}")]HttpRequestMessage request, 
            long trainingEventStudentID,
            ILogger log, 
            Microsoft.Azure.WebJobs.ExecutionContext context)
        {

            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Fetch the training event participants
					GetTrainingEventParticipant_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);
						
                        result = trainingService.GetTrainingEventStudent(trainingEventStudentID);
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
