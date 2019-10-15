using System;
using System.Net;
using System.Data.SqlClient;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Services.AppAuthentication;
using INL.Functions;
using INL.UserService.Client;
using INL.PersonService.Models;
using INL.PersonService.Data;


namespace INL.PersonService.Functions.HttpTriggers
{
    public static class UpdateUnitLibraryInfo
    {
        [FunctionName("UpdateUnitLibraryInfo")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "persons/{personID}/unitLibraryInfo/{unitLibraryID}")]HttpRequestMessage request, long personID, long unitLibraryID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Get parameter
					var saveUnitLibraryInfoParam = await request.Content.ReadAsAsyncCustom<SavePersonUnitLibraryInfo_Param>(new PersonServiceJsonConvertor().JsonConverters);

					// Ensure the personID was passed on the URL and matches the id in the payload
					if (personID == 0 || unitLibraryID == 0 || !saveUnitLibraryInfoParam.PersonID.HasValue || !saveUnitLibraryInfoParam.UnitID.HasValue)
					{
						throw new IndexOutOfRangeException();
					}

					if (personID != saveUnitLibraryInfoParam.PersonID || unitLibraryID != saveUnitLibraryInfoParam.UnitID)
					{
						throw new ArgumentException();
					}

                    // Save the unit library info
                    ISavePersonUnitLibraryInfo_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        // Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						saveUnitLibraryInfoParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;

						// Instantiate PersonService
						var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

						// Call the PersonService
						result = personService.SavePersonUnitLibraryInfo(saveUnitLibraryInfoParam);
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
