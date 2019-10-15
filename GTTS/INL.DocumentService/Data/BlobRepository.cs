using System;
using System.IO;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Dapper;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;

namespace INL.DocumentService.Data
{
    public class BlobRepository : IBlobRepository
    {
        private CloudBlobContainer cloudBlobContainer = null;
        private CloudBlobClient cloudBlobClient = null;
        private CloudStorageAccount cloudStorageAccount = null;
        private ILogger log = null;


		public BlobRepository(string blobConnectionString)
		{
			InitializeRepository(blobConnectionString, NullLogger.Instance);
		}


		public BlobRepository(string blobConnectionString, ILogger log)
		{
			InitializeRepository(blobConnectionString, log);
		}


		private void InitializeRepository(string blobConnectionString, ILogger log)
		{
			this.log = log;

			if (string.IsNullOrEmpty(blobConnectionString))
			{
				log.LogError("Empty blobConnectionString");
				throw new ArgumentException(nameof(blobConnectionString));
			}

			cloudStorageAccount = CloudStorageAccount.Parse(blobConnectionString);
			cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();
		}


		// Private method to get block container reference. Create the container if it does not exist 
		// <returns>
		// void
		// </returns>       
		private async Task<CloudBlobContainer> GetBlockContainer(string containerName)
		{
			var container = cloudBlobClient.GetContainerReference(containerName);
			await container.CreateIfNotExistsAsync();

			return container;
        }


        // Upload byte array to Azure Blob Storage
        /// <returns>
        /// Uri
        /// </returns>
        public async Task<Uri> SaveBlobAsync(string containerName, byte[] content)
		{
            try
            {
                cloudBlobContainer = await GetBlockContainer(containerName.ToLower()); // container name must be lower case

				// The name of the blob will be a unique GUID.  This enables us to store multiple
				// files with the same name.  Especially important for file versioning.
                string blobName = Guid.NewGuid().ToString();

                CloudBlockBlob blob = cloudBlobContainer.GetBlockBlobReference(blobName);

                await blob.UploadFromByteArrayAsync(content, 0, content.Length);

                return blob.Uri;
            }
            catch (Exception ex)
            {
                LogException("UploadBlobAsync", ex);
                throw;
            }
        }

		
        // Download a blob resource to byte array using uri
        /// <returns>
        /// Task<byte[]>
        /// </returns>
        public async Task<byte[]> GetBlobAsync(string uri)
        {
            try
            {
				byte[] bytes = null;

				var blobReference = await cloudBlobClient.GetBlobReferenceFromServerAsync(new Uri(uri));
				var sas = blobReference.GetSharedAccessSignature(
					new SharedAccessBlobPolicy
					{
						SharedAccessStartTime = DateTimeOffset.UtcNow.AddMinutes(-10),
						SharedAccessExpiryTime = DateTimeOffset.UtcNow.AddMinutes(10),
						Permissions = SharedAccessBlobPermissions.Read
					}
				);

				var blockBlob = new CloudBlockBlob(new Uri(uri + sas));

				if (blockBlob.ExistsAsync().Result)
				{
					await blockBlob.FetchAttributesAsync();
					bytes = new byte[blockBlob.Properties.Length];

					var downloadSize = await blockBlob.DownloadToByteArrayAsync(bytes, 0);
					if (downloadSize != blockBlob.Properties.Length)
					{
						throw new Exception("Download size does not match blob size.");
					}
                }

                return bytes ?? new byte[0];
            }
            catch (Exception ex)
            {
                LogException("DownloadBlobAsync", ex);
                throw;
            }
        }
		

        // Delete a blob resource by uri
        /// <returns>
        /// Task<bool>
        /// </returns>
        public async Task<bool> DeleteBlobAsync(string uri)
        {
            try
            {
                CloudBlockBlob blob = cloudBlobContainer.GetBlockBlobReference(new CloudBlockBlob(new Uri(uri)).Name);

                return await blob.DeleteIfExistsAsync();
            }
            catch (Exception ex)
            {
                LogException("DeleteBlobAsync", ex);
                throw;
            }
        }


        // Add container meta data
        /// <returns>
        /// Task
        /// </returns>
        public async Task<bool> AddContainerMetadataAsync(List<KeyValuePair<string, string>> metadata)
        {
            try
            {
                foreach (KeyValuePair<string, string> element in metadata)
                {
                    cloudBlobContainer.Metadata[element.Key] =  element.Value;
                }

                // Set the container's metadata.
                await cloudBlobContainer.SetMetadataAsync();

                return true;
            }
            catch (Exception ex)
            {
                LogException("AddContainerMetadataAsync", ex);
                throw;
            }
        }


        // Return a list of meta data associated with a container
        /// <returns>
        /// IDictionary <string, string>
        /// </returns>
        public async Task<IDictionary<string, string>> ListContainerMetadataAsync()
        {
            try
            {
                // Fetch container attributes in order to populate the container's properties and metadata.
                await cloudBlobContainer.FetchAttributesAsync();

                return cloudBlobContainer.Metadata;
            }
            catch (Exception ex)
            {
                LogException("ListContainerMetadataAsync", ex);
                throw;
            }
        }


        // Add individual blob meta data
        /// <returns>
        /// Task
        /// </returns>
        public async Task<bool> AddBlobMetadataAsync(string uri, BlobMetaDataEntity metadata)
        {
            try
            {
                var blockBlob = new CloudBlockBlob(new Uri(uri));
                CloudBlockBlob blob = cloudBlobContainer.GetBlockBlobReference(new CloudBlockBlob(new Uri(uri)).Name);

				var properties = metadata.GetProperties();
				foreach (string key in properties.Keys)
                {
                    blob.Metadata[key] = properties[key];
                }

                // Set the container's metadata.
                await blob.SetMetadataAsync();

                return true;
            }
            catch (Exception ex)
            {
                LogException("AddBlobMetadataAsync", ex);
                throw;
            }
        }


        // Return a list of meta data associated with a BLOB resource
        /// <returns>
        /// IDictionary <string, string>
        /// </returns>
        public async Task<BlobMetaDataEntity> ListBlobMetadataAsync(string uri)
        {
            try
            {
                CloudBlockBlob blob = cloudBlobContainer.GetBlockBlobReference(new CloudBlockBlob(new Uri(uri)).Name);
                await blob.FetchAttributesAsync();

                return new BlobMetaDataEntity(blob.Metadata);
			}
            catch (Exception ex)
            {
                LogException("ListBlobMetadataAsync", ex);
                throw;
            }

        }


        // Set block content type
        /// <returns>
        /// Task
        /// </returns>
        public async Task<bool> SetBlobContentTypeAsync(string uri, string contentType)
        {
            try
            {
                CloudBlockBlob blob = cloudBlobContainer.GetBlockBlobReference(new CloudBlockBlob(new Uri(uri)).Name);
                blob.Properties.ContentType = contentType;
                await blob.SetPropertiesAsync();

                return true;
            }
            catch (Exception ex)
            {
                LogException("SetBlobContentTypeAsync", ex);
                throw;
            }
        }


        // Return a list of properties associated with a BLOB resource
        /// <returns>
        /// Task<Properties>
        /// </returns>
        public async Task<BlobProperties> ListBlobPropertiesAsync(string uri)
        {
            try
            {
                // Fetch container attributes in order to populate the container's properties and metadata.
                CloudBlockBlob blob = cloudBlobContainer.GetBlockBlobReference(new CloudBlockBlob(new Uri(uri)).Name);
                await blob.FetchAttributesAsync();

                return blob.Properties;
            }
            catch (Exception ex)
            {
                LogException("ListBlobPropertiesAsync", ex);
                throw;
            }
        }


        // Get the blob content type
        // <returns>
        // string
        // </returns>        
        public async Task<string> GetBlobContentTypeAsync(string uriStr)
        {
            try
			{
				var result = await ListBlobPropertiesAsync(uriStr);
				return result.ContentType;
            }
            catch (Exception ex)
            {
                LogException("GetBlobContentTypeAsync", ex);
                throw;
            }
        }


        private void LogException(string methodName, Exception ex)
        {
            if (ex is StorageException)
            {
				var requestInformation = ((StorageException)ex).RequestInformation;
                log.LogError("In {0}, exception is thrown: {1}", methodName, requestInformation.HttpStatusMessage);

                // get more details about the exception 
                var information = requestInformation.ExtendedErrorInformation;
                log.LogError("Error code: {0}; Error Message {1}", information.ErrorCode, information.ErrorMessage);
            } 
			else
            {
                log.LogError("In {0}, exception is thrown: {1}", methodName, ex.Message);
            }
        }
    }
}