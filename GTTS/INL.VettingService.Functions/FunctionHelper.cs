using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs;
using INL.Functions;
using INL.UserService.Client;
using INL.DocumentService.Client;
using INL.TrainingService.Client;
using INL.MessagingService.Client;

namespace INL.VettingService.Functions
{
	public class FunctionHelper : FunctionHelperBase
	{
		private static Configuration staticConfiguration;
		public Configuration Configuration { get { return staticConfiguration; } }
		public override string ThisFunctionAppid { get { return Configuration.INLVettingServiceAppid; } }
		public override string ThisFunctionAppkey { get { return Configuration.INLVettingServiceAppkey; } }
		public override string ThisFunctionConnectionString { get { return Configuration.INLVettingServiceConnectionString; } }



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

        public async Task<TrainingServiceClient> GetTrainingServiceClientAsync()
        {
            var authToken = this.FunctionAuth.AcquireClientTokenAsync(
                this.BearerToken,                                // this request's bearer token
                this.ThisFunctionAppid,                          // calling function app id
                this.ThisFunctionAppkey,                         // calling function app key
                Configuration.INLTrainingServiceAppid,           // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new TrainingServiceClient(Configuration.INLTrainingServiceURL, await authToken);
        }

		public async Task<MessagingServiceClient> GetMessagingServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLMessagingServiceAppid,          // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new MessagingServiceClient(Configuration.INLMessagingServiceURL, await authToken);
		}

	}
}
