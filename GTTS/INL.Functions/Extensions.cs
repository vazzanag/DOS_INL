using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace INL.Functions
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



		public static T GetQueryParametersAsObject<T>(this HttpRequestMessage request) where T : new()
		{
			var result = new T();
			var resultType = result.GetType();
			var resultProperties = resultType.GetProperties();
			var queryParams = HttpUtility.ParseQueryString(request.RequestUri.Query);

			foreach (var property in resultProperties)
			{
				int intTryParseOutput;
				long longTryParseOutput;
				decimal decimalTryParseOutput;
				bool boolTryParseOutput;
				DateTime dateTimeTryParseOutput;

				var propertyType = property.PropertyType;
				if (propertyType.Name.StartsWith("Nullable")) {
					propertyType = propertyType.GenericTypeArguments.First();
				}

				var matchedKey = queryParams.AllKeys.LastOrDefault(k => k.ToLower() == property.Name.ToLower());
				if (!string.IsNullOrWhiteSpace(matchedKey)) 
				{
					var matchedValue = queryParams[matchedKey];

					if (System.Type.GetTypeCode(propertyType) == System.TypeCode.String)
					{
                        if (matchedValue == null || matchedValue.ToLower().Trim() == "null" || matchedValue.ToLower().Trim() == "undefined")
                            property.SetValue(result, null);
                        else
                            property.SetValue(result, matchedValue);
					}

					if (System.Type.GetTypeCode(propertyType) == System.TypeCode.Int16
						|| System.Type.GetTypeCode(propertyType) == System.TypeCode.UInt16
						|| System.Type.GetTypeCode(propertyType) == System.TypeCode.Int32 
						|| System.Type.GetTypeCode(propertyType) == System.TypeCode.UInt32)
					{
						if (int.TryParse(matchedValue, out intTryParseOutput))
						{
							property.SetValue(result, intTryParseOutput);
						}
					}

					if (System.Type.GetTypeCode(propertyType) == System.TypeCode.Int64)
					{
						if (long.TryParse(matchedValue, out longTryParseOutput))
						{
							property.SetValue(result, longTryParseOutput);
						}
					}

					if (System.Type.GetTypeCode(propertyType) == System.TypeCode.Decimal)
					{
						if (decimal.TryParse(matchedValue, out decimalTryParseOutput))
						{
							property.SetValue(result, decimalTryParseOutput);
						}
					}

					if (System.Type.GetTypeCode(propertyType) == System.TypeCode.Boolean)
					{
						if (bool.TryParse(matchedValue, out boolTryParseOutput))
						{
							property.SetValue(result, boolTryParseOutput);
						}
					}

					if (System.Type.GetTypeCode(propertyType) == System.TypeCode.DateTime)
					{
						if (DateTime.TryParse(matchedValue, out dateTimeTryParseOutput))
						{
							property.SetValue(result, dateTimeTryParseOutput);
						}
					}

				}
			}

			return result;
		}
    }
}
