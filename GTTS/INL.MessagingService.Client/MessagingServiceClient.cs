using System;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using Newtonsoft.Json;
using INL.MessagingService.Client.Models;
using System.Net.Http.Headers;
using System.Collections.Generic;

namespace INL.MessagingService.Client
{
    public class MessagingServiceClient : IMessagingServiceClient, IDisposable
    {
        private HttpClient http;
        private string accessToken;

        public MessagingServiceClient(string baseURL, string accessToken)
        {
            this.accessToken = accessToken;
            this.http = new HttpClient();
            this.http.BaseAddress = new Uri($"{baseURL}/");
        }

        public async Task<long> CreateRosterUploadedNotification(ICreateNotification_Param createNotificationParam)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/rosteruploaded");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
            newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to create notification.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<long>(resultAsJSON);

            return result;
        }

		public async Task<long> CreateVettingBatchCreatedNotification(ICreateNotification_Param createNotificationParam)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/vettingbatchcreated");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
			newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to create notification.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<long>(resultAsJSON);

			return result;
		}
				
		public async Task<List<long>> CreatePersonsVettingVettingTypeCreatedNotification(ICreateNotification_Param createNotificationParam)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/personsvettingvettingtypecreated");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
			newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to create notification.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<List<long>>(resultAsJSON);

			return result;
		}

		public async Task<long> CreateVettingBatchCourtesyCompletedNotification(ICreateNotification_Param createNotificationParam, int vettingTypeID)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/vettingbatchcourtesycompleted/{vettingTypeID}");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
			newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to create notification.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<long>(resultAsJSON);

			return result;
		}

		public async Task<long> CreateVettingBatchResultsNotifiedWithRejectionsNotification(ICreateNotification_Param createNotificationParam)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/vettingbatchresultsnotifiedwithrejections");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
			newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to create VettingBatchResultsNotifiedWithRejections notification.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<long>(resultAsJSON);

			return result;
		}

		public async Task<long> CreateVettingBatchResultsNotifiedNotification(ICreateNotification_Param createNotificationParam)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/vettingbatchresultsnotified");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
			newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to create VettingBatchResultsNotified notification.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<long>(resultAsJSON);

			return result;
		}

		public async Task<long> CreateVettingBatchAcceptedNotification(ICreateNotification_Param createNotificationParam)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/vettingbatchaccepted");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
			newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to create VettingBatchAccepted notification.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<long>(resultAsJSON);

			return result;
		}

		public async Task<long> CreateVettingBatchRejectedNotification(CreateNotification_Param createNotificationParam)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Post, $"notifications/vettingbatchrejected");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var createNotificationJson = JsonConvert.SerializeObject(createNotificationParam);
			newReq.Content = new StringContent(createNotificationJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to create VettingBatchRejected notification.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<long>(resultAsJSON);

			return result;
		}

		public void Dispose()
        {
            this.http.Dispose();
        }
	}
}
