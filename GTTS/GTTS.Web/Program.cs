using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace GTTS.Web
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

		public static IWebHostBuilder CreateWebHostBuilder(string[] args)
		{
			var configuration = new ConfigurationBuilder().Build();
			return WebHost.CreateDefaultBuilder(args).UseConfiguration(configuration)
				.UseStartup<Startup>();
		}
    }
}
