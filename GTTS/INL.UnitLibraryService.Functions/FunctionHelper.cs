using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs;
using INL.Functions;
using INL.LocationService.Client;
using INL.PersonService.Client;
using INL.UserService.Client;


namespace INL.UnitLibraryService.Functions
{
	public class FunctionHelper : FunctionHelperBase
	{
		private static Configuration staticConfiguration;
		public Configuration Configuration { get { return staticConfiguration; } }
		public override string ThisFunctionAppid { get { return Configuration.INLUnitLibraryServiceAppid; } }
		public override string ThisFunctionAppkey { get { return Configuration.INLUnitLibraryServiceAppkey; } }
		public override string ThisFunctionConnectionString { get { return Configuration.INLUnitLibraryServiceConnectionString; } }



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






	}
}
