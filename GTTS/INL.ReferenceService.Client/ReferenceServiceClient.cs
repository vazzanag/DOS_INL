using INL.ReferenceService.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace INL.ReferenceService.Client
{
    public class ReferenceServiceClient : IReferenceServiceClient, IDisposable
	{
        private HttpClient http;
        private string accessToken;

        public ReferenceServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
		}

		public void Dispose()
		{
			this.http.Dispose();
		}

		public async Task<ReferenceTables_Results> GetReferences(IGetReferenceTable_Param getReferenceTableParam)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"references?ReferenceList={getReferenceTableParam.ReferenceList}");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to retrieve references.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            ReferenceTables_Results result = new ReferenceTables_Results();
            result = JsonConvert.DeserializeObject<ReferenceTables_Results>(resultAsJSON);

            return result;
        }
    }
}
