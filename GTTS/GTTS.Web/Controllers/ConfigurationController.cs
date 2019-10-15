using System;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace GTTS.Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ConfigurationController : ControllerBase
    {
		private IConfiguration configuration { get; set; }

		public ConfigurationController(IConfiguration configuration) {
			this.configuration = configuration;
		}

		// GET: api/Configuration
		[HttpGet]
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/Configuration/Configs?{requestedConfigs}
        [HttpGet("Configs/{requestedConfigs}")]
        public JsonResult Get(string requestedConfigs)
        {
            var result = new Dictionary<string, string>();

			requestedConfigs.Split(",").ToList().ForEach(rc => result.Add(rc, configuration.GetValue<string>(rc)));
            
            return new JsonResult(result);
        }

        // POST: api/Configuration
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT: api/Configuration/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
