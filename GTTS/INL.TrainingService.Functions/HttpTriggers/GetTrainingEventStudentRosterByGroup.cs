using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using INL.ReferenceService.Client;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class GetTrainingEventStudentRosterByGroup
    {
        [FunctionName("GetTrainingEventStudentRosterByGroup")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "trainingevents/{trainingEventID}/trainingeventgroup/{trainingEventGroupID}/StudentRoster")]HttpRequestMessage request, long trainingEventID, long trainingEventGroupID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					bool loadData = false;
					var d = request.GetQueryNameValuePairs().FirstOrDefault(q => q.Key == "data");
					if (!String.IsNullOrWhiteSpace(d.Value))
					{
						bool boolTryParseOutput;
						if (bool.TryParse(d.Value, out boolTryParseOutput))
							loadData = boolTryParseOutput;
					}


					// Fetch the training event attachments
					IGetTrainingEventStudentRoster_Result roster = null;
					using (var referenceServiceClient = await helper.GetReferenceServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);

                        roster = trainingService.GenerateStudentRosterSpreadsheet(trainingEventID, trainingEventGroupID, loadData, referenceServiceClient);
                    }

                    // Return the result
                    var response = request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new ByteArrayContent(roster.ParticipantPerformanceRosterItem.FileContent);
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                    {
                        FileName = string.IsNullOrEmpty(roster.ParticipantPerformanceRosterItem.TrainingEventGroupName)
                                    ? string.Format("StudentRoster - {0} - Group - {1}.xlsx", roster.ParticipantPerformanceRosterItem.TrainingEventName, trainingEventGroupID)
                                    : string.Format("StudentRoster - {0} - Group - {1}.xlsx",
                                                    roster.ParticipantPerformanceRosterItem.TrainingEventName,
                                                    roster.ParticipantPerformanceRosterItem.TrainingEventGroupName)
                    };
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                    response.Content.Headers.Add("Access-Control-Expose-Headers", "Access-Control-Allow-Origin,Content-Disposition");

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
