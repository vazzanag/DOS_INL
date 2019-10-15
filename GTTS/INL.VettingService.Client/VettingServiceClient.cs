using System;
using System.Threading.Tasks;
using System.Net.Http;
using Newtonsoft.Json;
using INL.VettingService.Models;
using System.Net.Http.Headers;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Client
{
    public class VettingServiceClient : IVettingServiceClient, IDisposable
	{
		private HttpClient http;
        private string accessToken;

        public VettingServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
		}

		public void Dispose()
		{
			this.http.Dispose();
		}

		public async Task<GetPostVettingConfiguration_Result> GetPostVettingConfigurationAsync(int postID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"posts/{postID}/postConfiguration");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to load Post Configuration.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<GetPostVettingConfiguration_Result>(resultAsJSON);

            return result;
        }

        public async Task<IGetVettingBatch_Result> GetVettingBatch(long vettingBatchID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"batches/{vettingBatchID}");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get batch info.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<GetVettingBatch_Result>(resultAsJSON);

			return result;
		}

        public async Task<IGetPersonsVettings_Result> GetParticipantVettingsAsync(long personID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"persons/{personID}/vettings");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get participant vettings.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<GetPersonsVettings_Result>(resultAsJSON);

			return result;
		}

        public async Task<ICancelVettingBatch_Result> CancelVettingBatchesforEvent(long trainingEventID, bool isCancel)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Put, $"trainingEvents/{trainingEventID}?cancel={isCancel}");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to set cancel/uncancel vetting batches for training event.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<CancelVettingBatch_Result>(resultAsJSON);

            return result;
        }

        public async Task<IGetPersonVettingStatuses_Result> GetPersonVettingStatus(long personID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"persons/{personID}/vettingstatus");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get vetting status for person.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<GetPersonVettingStatuses_Result>(resultAsJSON);

            return result;
        }

        public async Task<IRemoveParticipantsFromVetting_Result> RemoveParticipantFromVetting(IRemoveParticipantFromVetting_Param param)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Put, $"trainingevents/{param.TrainingEventID}/participants/remove");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var removeParticipantJSON = JsonConvert.SerializeObject(param);
            newReq.Content = new StringContent(removeParticipantJSON, Encoding.UTF8, "application/json");

            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to remove participants from vetting.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<RemoveParticipantsFromVetting_Result>(resultAsJSON);

            return result;
        }
    }
}
