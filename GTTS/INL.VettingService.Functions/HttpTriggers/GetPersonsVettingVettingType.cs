using INL.Functions;
using INL.VettingService.Data;
using INL.VettingService.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading.Tasks;

namespace INL.VettingService.Functions.HttpTriggers
{
	public static class GetPersonsVettingVettingType
	{
		[FunctionName("GetPersonsVettingVettingType")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "personvetting/{personsVettingID}/vettingtypes/{vettingtypeID}")]HttpRequestMessage request, long personsVettingID, int vettingtypeID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var getPersonVettingVettingTypeParam = new GetPersonVettingVettingType_Param();
                    getPersonVettingVettingTypeParam.PersonsVettingID = personsVettingID;
                    getPersonVettingVettingTypeParam.VettingTypeID = vettingtypeID;

                    IGetPersonVettingVettingType_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantialize VettingService
						var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);

						// Call VettingService
						result = vettingService.GetPersonsVettingVettingType(getPersonVettingVettingTypeParam);
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

