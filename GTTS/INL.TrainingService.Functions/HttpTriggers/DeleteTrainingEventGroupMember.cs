using INL.Functions;
using INL.LocationService.Client;
using INL.PersonService.Client;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;

namespace INL.TrainingService.Functions.HttpTriggers
{
    public static class DeleteTrainingEventGroupMember
    {
        [FunctionName("DeleteTrainingEventGroupMember")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "trainingevents/{trainingEventID}/groups/{trainingEventGroupID}/members/{personID}")]HttpRequestMessage request,
            long trainingEventID,
            long trainingEventGroupID,
            long personID,
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

					
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate TrainingService
						var trainingRepository = new TrainingRepository(sqlConnection);
                        var trainingService = new TrainingService(trainingRepository);
						
                        DeleteTrainingEventGroupMember_Param param = new DeleteTrainingEventGroupMember_Param()
                        {
                            TrainingEventGroupID = trainingEventGroupID,
                            PersonID = personID
                        };
                        trainingService.DeleteTrainingEventGroupMember(param);
                    }


                    // Return the result
                    return request.CreateResponse(HttpStatusCode.OK);
				}
				catch (Exception ex)
				{
					return helper.CreateErrorResponse(ex);
				}
			}
		}
	}
}
