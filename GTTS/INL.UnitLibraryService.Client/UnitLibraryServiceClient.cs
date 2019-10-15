using System;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using Newtonsoft.Json;
using System.Net.Http.Headers;

using INL.Clients;
using INL.UnitLibraryService.Models;

namespace INL.UnitLibraryService.Client
{
	public class UnitLibraryServiceClient : IUnitLibraryServiceClient, IDisposable
	{
		private HttpClient http;
		private string accessToken;

		public UnitLibraryServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
		}

		public void Dispose()
		{
			this.http.Dispose();
		}


		public async Task<IGetUnits_Result> GetUnits(int countryID)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Get, $"countries/{countryID}/units");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to get units.");
			}

			var result = await httpResult.Content.ReadAsAsyncCustom<GetUnits_Result>(new UnitLibraryServiceClientJsonConvertor().JsonConverters);
			
			return result;
		}
	}
}
