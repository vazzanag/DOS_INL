using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.VettingService.Models;
using INL.VettingService.Data;

namespace INL.VettingService.Functions.HttpTriggers
{
	public static class SaveLeahyVettingHit
	{
		[FunctionName("SaveLeahyVettingHit")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "personvettings/{personVettingID}/leahyhit")]HttpRequestMessage request, long personVettingID, ILogger log, ExecutionContext context)
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
					var param = await request.Content.ReadAsAsyncCustom<SaveLeahyVettingHit_Param>(new VettingServiceJsonConvertor().JsonConverters);

					// Validate input
					if (personVettingID == 0)
					{
						throw new IndexOutOfRangeException();
					}

					// Ensure the id on the URL matches the id in the payload
					if (personVettingID != param.PersonsVettingID)
					{
						throw new ArgumentException();
					}

					// Save the leahy vetting hit 
					IGetPersonsLeahyVetting_Result result = null;

					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						param.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						var vettingRepository = new VettingRepository(sqlConnection);
						var vettingService = new VettingService(vettingRepository);

						result = vettingService.SaveLeahyVettingHit(param);
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