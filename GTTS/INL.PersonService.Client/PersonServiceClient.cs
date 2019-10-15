using System;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using Newtonsoft.Json;
using INL.PersonService.Models;
using System.Net.Http.Headers;

namespace INL.PersonService.Client
{
    public class PersonServiceClient : IPersonServiceClient, IDisposable
	{
		private HttpClient http;
        private string accessToken;

        public PersonServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
		}

		public void Dispose()
		{
			this.http.Dispose();
		}

		public async Task<GetPersonsWithUnitLibraryInfo_Result> GetPersons(string personList)
        {
            MultipartFormDataContent getPersonsParam = new MultipartFormDataContent();

            var newReq = new HttpRequestMessage(HttpMethod.Get, $"persons?ids={personList}");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get persons info.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<GetPersonsWithUnitLibraryInfo_Result>(resultAsJSON);

            return result;
        }

        public async Task<ISavePerson_Result> CreatePerson(ISavePerson_Param savePersonParam)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Post, $"persons");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var personJson = JsonConvert.SerializeObject(savePersonParam);
            newReq.Content = new StringContent(personJson, Encoding.UTF8, "application/json");
            
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to create person.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            ISavePerson_Result result = new SavePerson_Result();
            result = JsonConvert.DeserializeObject<SavePerson_Result>(resultAsJSON);

            return result;
        }

        public async Task<ISavePerson_Result> UpdatePerson(ISavePerson_Param savePersonParam)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Put, $"persons/" + savePersonParam.PersonID);
			newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

			var personJson = JsonConvert.SerializeObject(savePersonParam);
			newReq.Content = new StringContent(personJson, Encoding.UTF8, "application/json");

			var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to update person.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

			ISavePerson_Result result = new SavePerson_Result();
			result = JsonConvert.DeserializeObject<SavePerson_Result>(resultAsJSON);

            return result;
        }

        public async Task<IGetAllRanks_Result> GetRanksByCountryID(int countryID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"countries/{countryID}/ranks");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to get ranks.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<GetAllRanks_Result>(resultAsJSON);

            return result;
        }

        public async Task<SavePersonUnitLibraryInfo_Result> UpdateUnitLibraryInfo(SavePersonUnitLibraryInfo_Param savePersonUnitLibraryInfoParam)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Put, $"persons/" + savePersonUnitLibraryInfoParam.PersonID + "/unitLibraryInfo/" + savePersonUnitLibraryInfoParam.UnitID);
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var savePersonUnitLibraryInfoParamJson = JsonConvert.SerializeObject(savePersonUnitLibraryInfoParam);
            newReq.Content = new StringContent(savePersonUnitLibraryInfoParamJson, Encoding.UTF8, "application/json");

            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to update person Unit Library Info.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<SavePersonUnitLibraryInfo_Result>(resultAsJSON);

            return result;
        }
    }
}
