using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs;
using INL.Functions;
using INL.DocumentService.Client;
using INL.UserService.Client;
using INL.VettingService.Client;


namespace INL.MessagingService.Functions
{
	public class FunctionHelper : FunctionHelperBase
	{
		private static Configuration staticConfiguration;
		public Configuration Configuration { get { return staticConfiguration; } }
		public override string ThisFunctionAppid { get { return Configuration.INLMessagingServiceAppid; } }
		public override string ThisFunctionAppkey { get { return Configuration.INLMessagingServiceAppkey; } }
		public override string ThisFunctionConnectionString { get { return Configuration.INLMessagingServiceConnectionString; } }
        public string GTTSWebsiteURL { get { return Configuration.GTTSWebsiteURL; } }


		public FunctionHelper(HttpRequestMessage request, ExecutionContext context, ILogger log)
			: base(request, context, log)
		{
			if (staticConfiguration == null)
			{
				staticConfiguration = this.LoadConfigurationAsync<Configuration>().Result;
			}

			AuthorizeUser();
		}
			   

		public async Task<UserServiceClient> GetUserServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLUserServiceAppid,               // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new UserServiceClient(Configuration.INLUserServiceURL, await authToken);
		}


		public async Task<DocumentServiceClient> GetDocumentServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLDocumentServiceAppid,           // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new DocumentServiceClient(Configuration.INLDocumentServiceURL, await authToken);
		}

		public async Task<VettingServiceClient> GetVettingServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLVettingServiceAppid,               // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new VettingServiceClient(Configuration.INLVettingServiceURL, await authToken);
		}




	}
}
