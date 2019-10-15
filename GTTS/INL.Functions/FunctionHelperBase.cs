using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http;
using System.Linq;
using System.Data.SqlClient;
using System.Security.Authentication;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Newtonsoft.Json;
using INL.Services.Models;


namespace INL.Functions
{
	public abstract class FunctionHelperBase
	{
		private static ConfigurationBase staticConfigurationBase;
		protected readonly FunctionAuth FunctionAuth;
		protected readonly HttpRequestMessage request;
		protected readonly ILogger log;
		protected readonly ExecutionContext context;
		public string INLTenant { get { return staticConfigurationBase.INLTenant; } }
		public string INLTenantID { get { return staticConfigurationBase.INLTenantID; } }
		public string INLIdentityAuthorityURL { get { return staticConfigurationBase.INLIdentityAuthorityURL; } }
		public string INLIdentityIssuerURL { get { return staticConfigurationBase.INLIdentityIssuerURL; } }
		public string INLDatabaseTokenServiceURL { get { return staticConfigurationBase.INLDatabaseTokenServiceURL; } }
		public abstract string ThisFunctionAppid { get; }
		public abstract string ThisFunctionAppkey { get; }
		public abstract string ThisFunctionConnectionString { get; }

		public string BearerToken
		{
			get
			{
				string bearToken = null;

				if (request.Headers.Contains("Authorization"))
				{
					IEnumerable<string> headerValues = this.request.Headers.GetValues("Authorization");
					bearToken = headerValues.FirstOrDefault();

					// Remove "Bearer " from the extracted authorization header
					bearToken = bearToken.Replace("Bearer ", "");
				}

				return bearToken;
			}
		}


		public FunctionHelperBase(HttpRequestMessage request, ExecutionContext context, ILogger log)
		{
			if (request == null || context == null)
				throw new ArgumentException("Missing paramaters in FunctionHelper constructor.");

			this.log = log ?? NullLogger.Instance;
			this.request = request;
			this.context = context;

			if (staticConfigurationBase == null)
			{
				staticConfigurationBase = this.LoadConfigurationAsync<ConfigurationBase>().Result;
			}

			FunctionAuth = new FunctionAuth(log);
		}


		public async Task<T> LoadConfigurationAsync<T>() where T : new()
		{
			return await FunctionConfigurationLoader<T>.LoadConfigurationFromKeyVault();
		}

		public bool AuthorizeUser()
		{
			var tenantID = INLTenantID;
			var authority = string.Format(INLIdentityAuthorityURL, tenantID);
			var issuer = string.Format(INLIdentityIssuerURL, tenantID);
			var audience = ThisFunctionAppid;

			FunctionAuth.AuthenticateUser(BearerToken, authority, issuer, audience);

			if (!FunctionAuth.IsAuthenticated())
			{
				throw new AuthenticationException("NOT AUTHENTICATED");
			}
			else if (!FunctionAuth.IsAuthorized(context.FunctionName))
			{
				throw new AuthenticationException("NOT AUTHORIZED");
			}

			return true;
		}

		public string GetMyADOID()
		{
			return FunctionAuth.GetMyADOID();
		}

		public IEnumerable<string> GetMyAppRoles()
		{
			return FunctionAuth.GetMyAppRoles();
		}

		public async Task<SqlConnection> GetSqlConnectionAsync()
		{
			return await GetSqlConnectionAsync(ThisFunctionConnectionString);
		}

		public async Task<SqlConnection> GetSqlConnectionAsync(string connectionString)
		{
			var sqlConnection = new SqlConnection(connectionString);

			// If a user/pass is not specified in the connection string, assume we are using
			// and Managed Service Identity to connect to the database and fetch an access token.
			if (!connectionString.Contains(";Password=") && !connectionString.Contains("localhost"))
			{
				sqlConnection.AccessToken = await (new AzureServiceTokenProvider()).GetAccessTokenAsync(INLDatabaseTokenServiceURL);
			}

			return sqlConnection;
		}

		public HttpResponseMessage CreateErrorResponse(Exception ex)
		{
			if (ex is AuthenticationException)
			{
				if (ex.Message == "NOT AUTHENTICATED")
				{
					return CreateErrorResponse(request, HttpStatusCode.Unauthorized, "Not authenticated");
				}
				else if (ex.Message == "NOT AUTHORIZED")
				{
					return CreateErrorResponse(request, HttpStatusCode.Forbidden, "Not authorized");
				}

				return CreateErrorResponse(request, HttpStatusCode.Forbidden, "Not authorized");
			}
			else if (ex is ArgumentException)
			{
				return CreateErrorResponse(request, HttpStatusCode.BadRequest, ex.Message.Replace("\r\n", ". "));
			}
			else if (ex is IndexOutOfRangeException)
			{
				return CreateErrorResponse(request, HttpStatusCode.NotFound, ex.Message.Replace("\r\n", ". "));
			}
			else if (ex is ServiceException)
			{
				return CreateErrorResponse(request, HttpStatusCode.BadRequest, ex);
			}
			else
			{
				log.LogError(new EventId(), ex, $"{System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.FullName}: {ex.Message}");
#if DEBUG
				return CreateErrorResponse(request, HttpStatusCode.InternalServerError, new Exception($"Internal server error: {ex.Message}".Replace("\r\n", ". "), ex.InnerException));
#else
				return CreateErrorResponse(request, HttpStatusCode.InternalServerError, "Internal server error");
#endif
			}
		}


		// Dependency hell is making it impossible to use the libraries that provide HttpRequestMessage.CreateErrorResponse.
		// So we implement it poorly here.
		private HttpResponseMessage CreateErrorResponse(HttpRequestMessage httpRequestMessage, HttpStatusCode httpStatusCode, string message)
		{
			var response = httpRequestMessage.CreateResponse(httpStatusCode);
			response.ReasonPhrase = message;
			return response;
		}

		private HttpResponseMessage CreateErrorResponse(HttpRequestMessage httpRequestMessage, HttpStatusCode httpStatusCode, ServiceException serviceException)
		{
			var response = httpRequestMessage.CreateResponse(httpStatusCode);
			response.Content = new StringContent(JsonConvert.SerializeObject(serviceException.GetDetails()));
			return response;
		}

		private HttpResponseMessage CreateErrorResponse(HttpRequestMessage httpRequestMessage, HttpStatusCode httpStatusCode, Exception exception)
		{
			var response = httpRequestMessage.CreateResponse(httpStatusCode);
			response.Content = new StringContent(JsonConvert.SerializeObject(exception));
			return response;
		}



	}
}
