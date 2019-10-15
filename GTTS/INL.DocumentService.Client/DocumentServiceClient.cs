using System;
using System.IO;
using System.Threading.Tasks;
using System.Net.Http;
using Newtonsoft.Json;
using INL.DocumentService.Client.Models;
using System.Net.Http.Headers;

namespace INL.DocumentService.Client
{
    public class DocumentServiceClient : IDocumentServiceClient, IDisposable
	{
		private HttpClient http;
        private string accessToken;

		public DocumentServiceClient(string baseURL, string accessToken)
		{
			this.accessToken = accessToken;
			this.http = new HttpClient();
			this.http.BaseAddress = new Uri($"{baseURL}/");
		}

		public void Dispose()
		{
			this.http.Dispose();
		}

		public async Task<GetDocument_Result> GetDocumentAsync(GetDocument_Param getDocumentParam)
		{
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"documents/{getDocumentParam.FileID}?v={getDocumentParam.FileVersion}");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

			if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to load document.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<GetDocument_Result>(resultAsJSON);

			return result;
		}


		public async Task<GetDocumentInfo_Result> GetDocumentInfoAsync(GetDocumentInfo_Param getDocumentInfoParam)
		{
            var newReq = new HttpRequestMessage(HttpMethod.Get, $"documents/{getDocumentInfoParam.FileID}/info?v={getDocumentInfoParam.FileVersion}");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to load document details.");
			}
			
			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<GetDocumentInfo_Result>(resultAsJSON);
			
			return result;
		}


		public async Task<SaveDocument_Result> SaveDocumentAsync(SaveDocument_Param saveDocumentParam)
		{
			MultipartFormDataContent saveDocumentForm = new MultipartFormDataContent();
			saveDocumentForm.Add(new StreamContent(new MemoryStream(saveDocumentParam.FileContent)), "file");
			saveDocumentForm.Add(new StringContent(JsonConvert.SerializeObject(saveDocumentParam)), "params");

            var newReq = new HttpRequestMessage(HttpMethod.Post, $"documents");
            newReq.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            newReq.Content = saveDocumentForm;
            var httpResult = await http.SendAsync(newReq);

            if (!httpResult.IsSuccessStatusCode)
			{
				throw new Exception($"Failed to save document.");
			}

			var resultAsJSON = await httpResult.Content.ReadAsStringAsync();
			var result = JsonConvert.DeserializeObject<SaveDocument_Result>(resultAsJSON);

			return result;
		}


		public async Task<DeleteDocument_Result> DeleteDocumentAsync(DeleteDocument_Param deleteDocumentParam)
		{
			throw new NotImplementedException();
		}


	}
}
