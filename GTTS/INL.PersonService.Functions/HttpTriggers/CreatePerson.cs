using INL.Functions;
using INL.UserService.Client;
using INL.PersonService.Data;
using INL.PersonService.Models;
using INL.LocationService.Client;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Security.Authentication;


namespace INL.PersonService.Functions.HttpTriggers
{
    public static class CreatePerson
    {
        [FunctionName("CreatePerson")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "persons")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var savePersonParam = await request.Content.ReadAsAsyncCustom<SavePerson_Param>(new PersonServiceJsonConvertor().JsonConverters);
					
                    // POSTs are for new records.  The payload should not have an id because it is system generated.
                    savePersonParam.PersonID = -1;

                    // Save the person
                    ISavePerson_Result result = null;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var locationServiceClient = await helper.GetLocationServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();
						savePersonParam.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID;
						savePersonParam.Languages?.ForEach(l => l.ModifiedByAppUserID = myUserProfile.UserProfileItem.AppUserID);

						// Instantiate PersonService
						var personRepository = new PersonRepository(sqlConnection);
                        var personService = new PersonService(personRepository);

						// Call the PersonService
						result = personService.SavePerson(savePersonParam, locationServiceClient);
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

