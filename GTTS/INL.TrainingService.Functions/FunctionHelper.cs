using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs;
using INL.Functions;
using INL.DocumentService.Client;
using INL.LocationService.Client;
using INL.PersonService.Client;
using INL.ReferenceService.Client;
using INL.UnitLibraryService.Client;
using INL.UserService.Client;
using INL.VettingService.Client;
using INL.MessagingService.Client;


namespace INL.TrainingService.Functions
{
	public class FunctionHelper : FunctionHelperBase
	{
		private static Configuration staticConfiguration;
		public Configuration Configuration { get { return staticConfiguration; } }
		public override string ThisFunctionAppid { get { return Configuration.INLTrainingServiceAppid; } }
		public override string ThisFunctionAppkey { get { return Configuration.INLTrainingServiceAppkey; } }
		public override string ThisFunctionConnectionString { get { return Configuration.INLTrainingServiceConnectionString; } }



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


		public async Task<PersonServiceClient> GetPersonServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLPersonServiceAppid,             // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new PersonServiceClient(Configuration.INLPersonServiceURL, await authToken);
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
				Configuration.INLVettingServiceAppid,            // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new VettingServiceClient(Configuration.INLVettingServiceURL, await authToken);
		}


		public async Task<ReferenceServiceClient> GetReferenceServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLReferenceServiceAppid,          // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new ReferenceServiceClient(Configuration.INLReferenceServiceURL, await authToken);
		}


		public async Task<UnitLibraryServiceClient> GetUnitLibraryServiceClientAsync()
		{
			var authToken = this.FunctionAuth.AcquireClientTokenAsync(
				this.BearerToken,                                // this request's bearer token
				this.ThisFunctionAppid,                          // calling function app id
				this.ThisFunctionAppkey,                         // calling function app key
				Configuration.INLUnitLibraryServiceAppid,        // called function
				Configuration.INLIdentityAuthorityURL,           // authority URL
				Configuration.INLTenantID);                      // tenant ID
			return new UnitLibraryServiceClient(Configuration.INLUnitLibraryServiceURL, await authToken);
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
