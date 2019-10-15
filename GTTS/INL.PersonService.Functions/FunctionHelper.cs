using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs;
using INL.Functions;
using INL.LocationService.Client;
using INL.UserService.Client;
using INL.VettingService.Client;
using INL.TrainingService.Client;
using INL.DocumentService.Client;


namespace INL.PersonService.Functions
{
	public class FunctionHelper : FunctionHelperBase
	{
		private static Configuration staticConfiguration;
		public Configuration Configuration { get { return staticConfiguration; } }
		public override string ThisFunctionAppid { get { return Configuration.INLPersonServiceAppid; } }
		public override string ThisFunctionAppkey { get { return Configuration.INLPersonServiceAppkey; } }
		public override string ThisFunctionConnectionString { get { return Configuration.INLPersonServiceConnectionString; } }



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


		public async Task<LocationServiceClient> GetLocationServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLLocationServiceAppid,           // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new LocationServiceClient(Configuration.INLLocationServiceURL, await authToken);
		}


		public async Task<VettingServiceClient> GetVettingServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLVettingServiceAppid,            // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new VettingServiceClient(Configuration.INLVettingServiceURL, await authToken);
		}


		public async Task<TrainingServiceClient> GetTrainingServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLTrainingServiceAppid,            // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new TrainingServiceClient(Configuration.INLTrainingServiceURL, await authToken);
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



    }
}
