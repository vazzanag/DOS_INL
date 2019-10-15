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
using INL.ReferenceService.Data;
using INL.ReferenceService.Models;
using System.Security.Authentication;

namespace INL.ReferenceService.Functions.HttpTriggers
{
	public static class GetTrainingReferences
	{
		[FunctionName("GetTrainingReferences")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "references/training")]HttpRequestMessage request,
															ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();


					// Fetch Training Event reference data
					TrainingReference_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate ReferenceService
						var referenceRepository = new ReferenceRepository(sqlConnection);
						var referenceService = new ReferenceService(referenceRepository);

						// Call the ReferenceService
						result = referenceService.GetTrainingReferences();
					}

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
