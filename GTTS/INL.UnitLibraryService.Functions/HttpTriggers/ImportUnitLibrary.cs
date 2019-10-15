using INL.Functions;
using INL.LocationService.Client;
using INL.UnitLibraryService.Data;
using INL.UnitLibraryService.Models;
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
using System.Web.Http;

namespace INL.UnitLibraryService.Functions.HttpTriggers
{
    public class ImportUnitLibrary
    {
        [FunctionName("ImportUnitLibrary")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "units/import")]HttpRequestMessage request,
            ILogger log,
            ExecutionContext context)
        {
            using (log.BeginScope(context.InvocationId.ToString()))
            {
                // Check if this is a multipart/form-data POST
                if (!request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
				}

				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				try
				{
					// Authorize the user
					helper.AuthorizeUser();

					// Read multipart/form-data request
					var provider = new MultipartMemoryStreamProvider();
                    await request.Content.ReadAsMultipartAsync(provider);

                    // Get document stream and other form data
                    if (provider.Contents.Count <= 0)
                    {
                        throw new HttpResponseException(HttpStatusCode.BadRequest);
                    }

                    byte[] fileContent = null;
                    foreach (var content in provider.Contents)
                    {
                        string name = content.Headers.ContentDisposition.Name.Trim('\"');

                        switch (name)
                        {
                            case "file":
                                fileContent = await content.ReadAsByteArrayAsync();
                                break;
                            default:
                                break;
                        }
                    }

                    if (fileContent == null || fileContent.Length <= 0)
                    {
                        return request.CreateErrorResponse(HttpStatusCode.BadRequest, "No file included in request.");
                    }

                    ImportUnitLibrary_Result result;
					using (var userService = await helper.GetUserServiceClientAsync())
					using (var locationService = await helper.GetLocationServiceClientAsync())
					using (var personService = await helper.GetPersonServiceClientAsync())
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
						// Get the requester's AppUserID and set as ModifiedByAppUserID
						var myUserProfile = await userService.GetMyProfile();

                        var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository, log);

                        result = await unitLibraryService.ImportUnitLibrarySpreadsheet(myUserProfile.UserProfileItem.CountryID.Value, myUserProfile.UserProfileItem.AppUserID, fileContent, locationService, personService);
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
