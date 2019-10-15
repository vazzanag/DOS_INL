using System;
using System.Collections.Generic;
using System.Web;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace INL.Clients
{
	public static class Extensions
	{
		public static Task<T> ReadAsAsyncCustom<T>(this HttpContent content, List<JsonConverter> converters = null)
		{
			return (converters == null ? content.ReadAsAsync<T>() :
					content.ReadAsAsync<T>(new List<MediaTypeFormatter>() {
						new JsonMediaTypeFormatter {
							SerializerSettings = new JsonSerializerSettings {
								Converters = converters } }}));
		}


		public static T ReadAsMultipartAsyncCustom<T>(this HttpContent content, out byte[] fileContent, List<JsonConverter> converters = null) where T : new()
		{
			fileContent = null;

			// Check if this is a multipart/form-data POST
			if (!content.IsMimeMultipartContent())
			{
				throw new ArgumentException("UNSUPPORTED MEDIA TYPE");
			}

			// Read multipart/form-data request
			var provider = new MultipartMemoryStreamProvider();
			content.ReadAsMultipartAsync(provider).Wait();

			// Get document stream and other form data
			if (provider.Contents.Count <= 0)
			{
				throw new ArgumentException("NO FILE");
			}

			T param = new T();
			foreach (var providerContent in provider.Contents)
			{
				string name = providerContent.Headers.ContentDisposition.Name.Trim('\"');

				switch (name)
				{
					case "file":
						fileContent = providerContent.ReadAsByteArrayAsync().Result;
						break;
					case "params":
						param = JsonConvert.DeserializeObject<T>(providerContent.ReadAsStringAsync().Result);
						break;
					default:
						break;
				}
			}

			return param;
		}
	}
}
