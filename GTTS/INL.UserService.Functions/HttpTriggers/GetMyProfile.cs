using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Security.Authentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Logging;
using INL.Functions;
using INL.UserService.Models;
using INL.UserService.Data;

namespace INL.UserService.Functions.HttpTriggers
{
	public static class GetMyProfile
	{
		private const int CACHE_TTL_MILLIS = 60000;
		private static ISet<UserCacheItem> userCache;

		[FunctionName("GetMyProfile")]
		public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "me")]HttpRequestMessage request, ILogger log, Microsoft.Azure.WebJobs.ExecutionContext context)
		{
			using (log.BeginScope(context.InvocationId.ToString()))
			{
				// Init the FunctionHelper
				var helper = new FunctionHelper(request, context, log);

				bool noCache = request.GetQueryNameValuePairs().FirstOrDefault(p => p.Key.ToLower() == "no-cache").Value == "true";

				try
				{
					// Get the user's Active Directory ID
					var adoid = helper.GetMyADOID();

					// Declare result var
					IGetAppUserProfile_Result result = null;

					// Init cache, if necessary
					if (userCache == null)
					{
						userCache = new HashSet<UserCacheItem>();
					}

					// If no-cache, remove the entry from the cache to force fetch from database
					if (noCache) 
					{
						userCache.Remove(userCache.FirstOrDefault(u => u.ADOID == adoid));
					}

					// Query cache
					var cacheHit = userCache.FirstOrDefault(u => u.ADOID == adoid);
					
					if (cacheHit == null || cacheHit.Expires < DateTime.Now)
					{ // User not found or cache hit is stale.  Fetch from DB.	
						using (var sqlConnection = await helper.GetSqlConnectionAsync())
						{
							// Instantiate UserService
							var userRepository = new UserRepository(sqlConnection);
							var userService = new UserService(userRepository, log);

							// Call UserService
							result = userService.GetAppUserProfileByADOID(adoid, helper.GetMyAppRoles());
						}

						if (cacheHit == null) 
						{ // On cache miss, add the UserCacheItem
							userCache.Add(
								new UserCacheItem
								{
									ADOID = adoid,
									Profile = result,
									Expires = DateTime.Now.AddMilliseconds(CACHE_TTL_MILLIS)
								}
							);
						}
						else 
						{ // On stale hit, update the hit.
							cacheHit.Expires = DateTime.Now.AddMilliseconds(CACHE_TTL_MILLIS);
							cacheHit.Profile = result;
						}
					}
					else
					{ // Good cache hit.  We will return this.
						result = cacheHit.Profile;
					}

					return request.CreateResponse(HttpStatusCode.OK, result, "application/json");
				}
				catch (Exception ex)
				{
					log.LogCritical(ex.Message);
					return helper.CreateErrorResponse(ex);
				}
			}
		}
	}

	class UserCacheItem 
	{
		public string ADOID;
		public DateTime Expires;
		public IGetAppUserProfile_Result Profile;
	}
}
