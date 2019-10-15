using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using INL.LocationService.Models;
using INL.LocationService.Data;

namespace INL.LocationService.Functions.HttpTriggers
{
	public static class GetCountries
	{
		[FunctionName("GetCountries")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "countries")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Fetch the countries
					IGetCountries_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Instantiate LocationService
						var locationRepository = new LocationRepository(sqlConnection);
						var locationService = new LocationService(locationRepository);

						// Call LocationService
						result = locationService.GetCountries();
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
