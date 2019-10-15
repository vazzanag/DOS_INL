using System;
using System.Threading.Tasks;
using System.Net.Http;
using Newtonsoft.Json;
using INL.TrainingService.Models;
using System.Net.Http.Headers;

namespace INL.TrainingService.Client
{

	public class TrainingServiceClient : ITrainingServiceClient, IDisposable
	{
		private HttpClient http;
		private string accessToken;

		public TrainingServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
		}

		public void Dispose()
		{
			this.http.Dispose();
		}

		public async Task<IGetPersonsTrainingEvents_Result> GetPersonsTrainingEventsAsync(long personID, string trainingEventStatus)
		{
			var newReq = new HttpRequestMessage(HttpMethod.Get, $"persons/{personID}/trainingevents?trainingeventstatus={trainingEventStatus}");
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to get persons training info.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<GetPersonsTrainingEvents_Result>(resultAsJSON);

            return result;
        }

        public async Task<IGetTrainingEventParticipants_Result> GetTrainingEventRemovedParticipants(long trainingEventID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"trainingevents/{trainingEventID}/removedparticipants");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get removed participants.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            GetTrainingEventParticipants_Result result = new GetTrainingEventParticipants_Result();
            result = JsonConvert.DeserializeObject<GetTrainingEventParticipants_Result>(resultAsJSON);

            return result;
        }

        public async Task<IGetTrainingEventLocations_Result> GetTrainingEventLocations(long trainingEventID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"trainingevents/{trainingEventID}/locations");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get locations.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            IGetTrainingEventLocations_Result result = new GetTrainingEventLocations_Result();
            result = JsonConvert.DeserializeObject<GetTrainingEventLocations_Result>(resultAsJSON);

            return result;
        }

        public async Task<IGetTrainingEventParticipants_Result> GetTrainingEventParticipants(long trainingEventID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"trainingevents/{trainingEventID}/participants");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get event participants.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            GetTrainingEventParticipants_Result result = new GetTrainingEventParticipants_Result();
            result = JsonConvert.DeserializeObject<GetTrainingEventParticipants_Result>(resultAsJSON);

            return result;
        }
    }
}
