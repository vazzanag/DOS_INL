using System;
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


namespace INL.UnitLibraryService.Functions.HttpTriggers
{
    public class UpdateUnitParent
    {
        [FunctionName("UpdateUnitParent")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "units/{unitID}/unitparent")]HttpRequestMessage request, int unitID, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
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
					var updateUnitParentParam = await request.Content.ReadAsAsync<UpdateUnitParent_Param>();

                    // Validate input
                    if (unitID == 0)
					{
						throw new IndexOutOfRangeException();
					}

                    if (unitID != updateUnitParentParam.UnitID)
					{
						throw new ArgumentException();
					}


                    // Create result object
                    IUpdateUnitParent_Result result = null;
					using (var sqlConnection = await helper.GetSqlConnectionAsync())
					{
                        var unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
                        var unitLibraryService = new UnitLibraryService(unitLibraryRepository);

                        result = unitLibraryService.UpdateUnitParent(updateUnitParentParam);
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
