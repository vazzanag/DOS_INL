using System;
using System.Linq;
using System.Security.Claims;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Globalization;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Extensions.Logging.Abstractions;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using Microsoft.IdentityModel.Protocols;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;

namespace INL.Functions
{
	public sealed class FunctionAuth
	{
		private static IConfigurationManager<OpenIdConnectConfiguration> openIdConnectConfigurationManager;
		private ILogger log = null;

		public FunctionAuth(ILogger log)
		{
			this.log = log ?? NullLogger.Instance;
		}


#if DEBUG
		public IEnumerable<string> GetMyAppRoles()
		{
			return new List<string>() {
				"INLGLOBALADMIN"
			}.AsEnumerable();
		}
#else
		public IEnumerable<string> GetMyAppRoles()
		{
			var claims = ClaimsPrincipal.Current.Claims;
			var roleClaims = claims.Where(u => u.Type.Equals("roles") || u.Type.Equals("http://schemas.microsoft.com/ws/2008/06/identity/claims/role"));
			var roleStrings = roleClaims.Select(r => r.Value.ToUpper());

			return roleStrings;
		}
#endif


#if DEBUG
		public ClaimsPrincipal AuthenticateUser(string bearerToken, string authority, string issuer, string audience)
		{
			this.log.LogCritical($"AuthenticateUser() - DEBUG MODE");
			return ClaimsPrincipal.Current;
		}
#else
		public ClaimsPrincipal AuthenticateUser(string bearerToken, string authority, string issuer, string audience)
		{
			ClaimsPrincipal.ClaimsPrincipalSelector = () => ValidateTokenAsync(bearerToken, authority, issuer, audience).Result;
			
			return ClaimsPrincipal.Current;
		}
#endif


#if DEBUG
		public bool IsAuthenticated()
		{
			this.log.LogCritical($"IsAuthenticated() - DEBUG MODE");
			return true;
		}
#else
		public bool IsAuthenticated()
		{
			return ClaimsPrincipal.Current.Identity.IsAuthenticated;
		}
#endif

#if DEBUG
		public bool IsAuthorized(string appRole)
		{
			this.log.LogCritical($"IsAuthorized() - DEBUG MODE");

			return true;
		}
#else
		public bool IsAuthorized(string appRole) 
        {
            if (appRole == null)
            {
                return false;
            }

			if (!IsAuthenticated())
			{
				return false;
			}

			var userRoles = GetMyAppRoles();
		
			if (userRoles.Count() > 0 && userRoles.Any(userRole =>
														   userRole.ToUpper().Equals("INLGTTSVIEWONLY")
														|| userRole.ToUpper().Equals("INLPROGRAMMANAGER")
														|| userRole.ToUpper().Equals("INLVETTINGCOORDINATOR")
														|| userRole.ToUpper().Equals("INLCOURTESYVETTER")
														|| userRole.ToUpper().Equals("INLLOGISTICSCOORDINATOR")
														|| userRole.ToUpper().Equals("INLPOSTADMIN")
														|| userRole.ToUpper().Equals("INLAGENCYADMIN")
														|| userRole.ToUpper().Equals("INLGLOBALADMIN")))
			{
				return true;
			}
			
			log.LogError($"USER IS NOT AUTHORIZED");
			log.LogError($"Requested appRole: {appRole}");
			var userClaimsFlat = ClaimsPrincipal.Current.Claims.Select(c => $"{c.Type}: {c.Value.ToString()}");
			log.LogError("User Claims:");
			log.LogError(string.Join(", ", userClaimsFlat));

			return false;
        }
#endif

#if DEBUG
		public string GetMyADOID()
		{
			this.log.LogCritical($"GetUserADOID() - DEBUG MODE");
			return "00000000-0000-0000-0000-000000000101";
		}
#else
		public string GetMyADOID()
		{
			var oid = ClaimsPrincipal.Current.Claims.FirstOrDefault(c => 
					c.Type == "oid" || c.Type == "http://schemas.microsoft.com/identity/claims/objectidentifier"
				).Value;

			return oid;
		}
#endif


#if DEBUG
		public async Task<string> AcquireClientTokenAsync(
				string callingFuncAccessToken,
				string callingFuncAppid,
				string callingFuncAppKey,
				string calledFuncAppid,
				string identityAuthorityURL,
				string tenantID)
		{
			return await Task<string>.FromResult("");
		}
#else
		public async Task<string> AcquireClientTokenAsync(
				string callingFuncAccessToken,
				string callingFuncAppid,
				string callingFuncAppKey,
				string calledFuncAppid,
				string identityAuthorityURL,
				string tenantID)
		{
			string calledFuncAccessToken = null;
			AuthenticationResult result = null;

			//
			// Use ADAL to get a token On Behalf Of the current user.  To do this we will need:
			//      The Resource ID of the service we want to call.
			//      The current user's access token, from the current request's authorization header.
			//      The credentials of this application.
			//      The username (UPN or email) of the user calling the API
			//
			ClientCredential clientCred = new ClientCredential(callingFuncAppid, callingFuncAppKey);

			string userName = ClaimsPrincipal.Current.FindFirst(ClaimTypes.Upn) != null ? ClaimsPrincipal.Current.FindFirst(ClaimTypes.Upn).Value : ClaimsPrincipal.Current.FindFirst(ClaimTypes.Email).Value;
			string userAccessToken = callingFuncAccessToken;

			UserAssertion userAssertion = new UserAssertion(userAccessToken, "urn:ietf:params:oauth:grant-type:jwt-bearer", userName);

			string authority = String.Format(CultureInfo.InvariantCulture, identityAuthorityURL, tenantID);
			string userId = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;

			AuthenticationContext authContext = new AuthenticationContext(authority);

			// In the case of a transient error, retry once after 1 second, then abandon.
			// Retrying is optional.  It may be better, for your application, to return an error immediately to the user and have the user initiate the retry.
			bool retry = false;
			int retryCount = 0;

			do
			{
				retry = false;
				try
				{
					result = await authContext.AcquireTokenAsync(calledFuncAppid, clientCred, userAssertion);
					calledFuncAccessToken = result.AccessToken;
				}
				catch (AdalException ex)
				{
					log.LogInformation("exception is thrown  - " + ex.Message);
					if (ex.ErrorCode == "temporarily_unavailable")
					{
						// Transient error, OK to retry.
						retry = true;
						retryCount++;
						Thread.Sleep(1000);
					}
				}
			} while ((retry == true) && (retryCount < 2));


			return calledFuncAccessToken;
		}
#endif







		public async Task<ClaimsPrincipal> ValidateTokenAsync(string bearerToken, string authority, string issuer, string audience)
		{
			if (openIdConnectConfigurationManager == null)
			{
				var wellKnown = $"{authority}.well-known/openid-configuration";
				var documentRetriever = new HttpDocumentRetriever { RequireHttps = authority.StartsWith("https://") };
				openIdConnectConfigurationManager = new ConfigurationManager<OpenIdConnectConfiguration>(
					wellKnown,
					new OpenIdConnectConfigurationRetriever(),
					documentRetriever
				);
			}
			ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
			ServicePointManager.SecurityProtocol &= ~(SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | SecurityProtocolType.Tls11);

			var config = await openIdConnectConfigurationManager.GetConfigurationAsync(CancellationToken.None);

			var validationParameter = new TokenValidationParameters
			{
				RequireSignedTokens = true,
				ValidAudience = audience,
				ValidateAudience = true,
				ValidIssuer = config.Issuer,
				ValidateIssuer = true,
				IssuerSigningKeys = config.SigningKeys,
				ValidateIssuerSigningKey = true,
				ValidateLifetime = true,
				ClockSkew = TimeSpan.FromMinutes(5)
			};

			ClaimsPrincipal result = null;
			var tries = 0;

			while (result == null && tries <= 1)
			{
				try
				{
					var handler = new JwtSecurityTokenHandler();
					result = handler.ValidateToken(bearerToken, validationParameter, out var token);
				}
				catch (SecurityTokenSignatureKeyNotFoundException ex)
				{
					this.log.LogCritical($"SecurityTokenSignatureKeyNotFoundExceptionL {ex.Message}");
					// This exception is thrown if the signature key of the JWT could not be found.
					// This could be the case when the issuer changed its signing keys, so we trigger a 
					// refresh and retry validation.
					openIdConnectConfigurationManager.RequestRefresh();
					tries++;
				}
				catch (SecurityTokenException ex)
				{
					this.log.LogCritical($"SecurityTokenException {ex.Message}");
					return null;
				}
			}

			return result;
		}

	}
}
