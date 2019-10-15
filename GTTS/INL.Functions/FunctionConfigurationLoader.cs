using System;
using System.Threading.Tasks;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.KeyVault;

namespace INL.Functions
{
    public static class FunctionConfigurationLoader<T> where T: new()
    {
		public static async Task<T> LoadConfigurationFromKeyVault()
		{
			var keyVaultURI = Environment.GetEnvironmentVariable("KeyVaultURI");
			if (String.IsNullOrWhiteSpace(keyVaultURI))
			{
				throw new Exception("KeyVaultURI not configured.");
			}
			
			var azureServiceTokenProvider = new AzureServiceTokenProvider();
			var keyVaultClient = new KeyVaultClient(
				new KeyVaultClient.AuthenticationCallback(azureServiceTokenProvider.KeyVaultTokenCallback)
			);
			
			var configuration = new T();
			var configurationType = configuration.GetType();
			var configurationFields = configurationType.GetFields();
			
			foreach (var field in configurationFields)
			{
				try
				{
					var configurationValue = await keyVaultClient.GetSecretAsync(keyVaultURI, field.Name);
					field.SetValue(configuration, configurationValue.Value);
				}
				catch (Exception ex)
				{
					throw new FunctionConfigurationNotFoundException(field.Name);
				}
			}


			return configuration;
		}

    }
}
