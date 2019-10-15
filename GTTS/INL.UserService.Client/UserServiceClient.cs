using System;
using System.Threading.Tasks;
using System.Security.Claims;
using System.Collections.Concurrent;
using System.Linq;
using System.Net.Http;
using Newtonsoft.Json;
using INL.UserService.Models;
using System.Net.Http.Headers;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;

namespace INL.UserService.Client
{
	public class UserServiceClient : IUserServiceClient, IDisposable
	{
		private HttpClient http;
		private string accessToken;
		private ILogger log;

		public UserServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
			this.log = NullLogger.Instance;
		}

		public UserServiceClient(string baseURL, string accessToken, ILogger log)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
			this.log = log;
		}

		public void Dispose()
		{
			this.http.Dispose();
		}
		
		public async Task<IGetAppUserProfile_Result> GetMyProfile()
		{
			var newReq = new HttpRequestMessage(HttpMethod.Get, $"me");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to get user info.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<IGetAppUserProfile_Result>(resultAsJSON, new UserServiceJsonConvertor().JsonConverters.ToArray());
			
			return result;
		}

		public async Task<IGetAppUsers_Result> GetAppUsers(int? countryID, int? postID, int? appRoleID, int? businessUnitID)
		{
			var queryParameters = "?";
			if (countryID.HasValue)
				queryParameters += $"countryID={countryID}&";
			if (postID.HasValue)
				queryParameters += $"postID={postID}&";
			if (appRoleID.HasValue)
				queryParameters += $"appRoleID={appRoleID}&";
			if (businessUnitID.HasValue)
				queryParameters += $"businessUnitID={businessUnitID}&";

			queryParameters = queryParameters.Length > 1 ? queryParameters : "";
			if (queryParameters.EndsWith("&")) queryParameters = queryParameters.Substring(0, queryParameters.Length - 1);

			var newReq = new HttpRequestMessage(HttpMethod.Get, $"users{queryParameters}");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to get users.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<IGetAppUsers_Result>(resultAsJSON, new UserServiceJsonConvertor().JsonConverters.ToArray());

			return result;
		}
	}
}
