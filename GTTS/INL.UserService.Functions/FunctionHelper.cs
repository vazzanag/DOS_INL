using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs;
using INL.Functions;


namespace INL.UserService.Functions
{
	public class FunctionHelper : FunctionHelperBase
	{
		private static Configuration staticConfiguration;
		public Configuration Configuration { get { return staticConfiguration; } }
		public override string ThisFunctionAppid { get { return Configuration.INLUserServiceAppid; } }
		public override string ThisFunctionAppkey { get { return Configuration.INLUserServiceAppkey; } }
		public override string ThisFunctionConnectionString { get { return Configuration.INLUserServiceConnectionString; } }
		

		public FunctionHelper(HttpRequestMessage request, ExecutionContext context, ILogger log)
			: base(request, context, log)
		{
			if (staticConfiguration == null)
			{
				staticConfiguration = this.LoadConfigurationAsync<Configuration>().Result;
			}

			AuthorizeUser();
		}






	}
}
