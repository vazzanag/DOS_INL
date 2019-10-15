using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Data.SqlClient;
using System.Security.Authentication;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.UnitLibraryService.Models;
using INL.UnitLibraryService.Data;
using INL.PersonService.Client;
using INL.LocationService.Client;
using INL.UserService.Client;

namespace INL.UnitLibraryService.Functions.HttpTriggers
{
    public static class UpdateUnit
    {
        [FunctionName("UpdateUnit")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "units/{unitID}")]HttpRequestMessage request, int unitID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var saveUnitParam = await request.Content.ReadAsAsyncCustom<SaveUnit_Param>(new UnitLibraryServiceJsonConvertor().JsonConverters);

                    // Validate input
                    if (unitID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    if (unitID != saveUnitParam.UnitID)
					{
						throw new ArgumentException();
					}
					

                    // Create result object
                    SaveUnit_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var locationServiceClient = await helper.GetLocationServiceClientAsync())
					using (var personServiceClient = await helper.GetPersonServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveUnitParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate UnitLibraryService
						var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository);

                        result = unitLibraryService.SaveUnit(saveUnitParam, locationServiceClient, personServiceClient);
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
