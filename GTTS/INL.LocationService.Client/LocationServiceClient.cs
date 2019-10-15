using INL.LocationService.Client.Models;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace INL.LocationService.Client
{
    public class LocationServiceClient : ILocationServiceClient, IDisposable
	{
		private HttpClient http;
        private string accessToken;

        public LocationServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
		}

		public void Dispose()
		{
			this.http.Dispose();
		}

		public async Task<IFetchLocationByAddress_Result> FetchLocationByAddress(IFetchLocationByAddress_Param fetchLocationParam)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Post, $"locations");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var locationJson = JsonConvert.SerializeObject(fetchLocationParam);
            newReq.Content = new StringContent(locationJson, Encoding.UTF8, "application/json");

            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to retrieve location.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            IFetchLocationByAddress_Result result = new FetchLocationByAddress_Result();
            result = JsonConvert.DeserializeObject<FetchLocationByAddress_Result>(resultAsJSON);

            return result;
        }

        public async Task<IGetCitiesByStateID_Result> GetCitiesByStateID(int stateID)
        {
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"states/{stateID}/cities");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to load cities of a state.");

            }
            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            GetCitiesByStateID_Result result = new GetCitiesByStateID_Result();
            result = JsonConvert.DeserializeObject<GetCitiesByStateID_Result>(resultAsJSON);

            return result;
        }

        public async Task<FindCity_Result> FindCityByCityNameStateNameAndCountryName(FindCityByCityNameStateNameAndCountryName_Param param)
        {
            string uri = $"city?cityName={Uri.EscapeUriString(param.CityName)}&stateName={Uri.EscapeUriString(param.StateName)}&countryName={Uri.EscapeUriString(param.CountryName)}";
            var newReq = new HttpRequestMessage(HttpMethod.Get, uri);
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to retrieve city.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<FindCity_Result>(resultAsJSON);

            return result;
        }

        public async Task<FindCity_Result> FindCityByCityNameStateNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param)
        {
            string uri = $"countries/{param.CountryID}/city?cityName={Uri.EscapeUriString(param.CityName)}&stateName={Uri.EscapeUriString(param.StateName)}";
            var newReq = new HttpRequestMessage(HttpMethod.Get, uri);
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to retrieve city.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            FindCity_Result result = new FindCity_Result();
            result = JsonConvert.DeserializeObject<FindCity_Result>(resultAsJSON);

            return result;
        }

        public async Task<FindCity_Result> FindCityByCityNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param)
        {
            string uri = $"countries/{param.CountryID}/city?cityName={Uri.EscapeUriString(param.CityName)}&stateName=";
            var newReq = new HttpRequestMessage(HttpMethod.Get, uri);
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to retrieve city.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            FindCity_Result result = new FindCity_Result();
            result = JsonConvert.DeserializeObject<FindCity_Result>(resultAsJSON);

            return result;
        }

        public async Task<FindCity_Result> FindOrCreateCityByCityNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param)
        {
            string uri = $"countries/{param.CountryID}/city?cityName={Uri.EscapeUriString(param.CityName)}&stateName={Uri.EscapeUriString(param.StateName)}&canCreate=true";
            var newReq = new HttpRequestMessage(HttpMethod.Get, uri);
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
            {
                throw new Exception($"Failed to retrieve city.");
            }

            var resultAsJSON = await httpResult.Content.ReadAsStringAsync();

            FindCity_Result result = new FindCity_Result();
            result = JsonConvert.DeserializeObject<FindCity_Result>(resultAsJSON);

            return result;
        }
    }
}
