using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using INL.DocumentService.Data;
using INL.DocumentService.Models;
using Microsoft.WindowsAzure.Storage.Blob;

namespace INL.DocumentService.Data
{
    public interface IBlobRepository
    {       
        Task<byte[]> GetBlobAsync(string uri);
		Task<string> GetBlobContentTypeAsync(string uri);
		Task<Uri> SaveBlobAsync(string containerName, byte[] content);
        Task<bool> DeleteBlobAsync(string uri);
        Task<BlobMetaDataEntity>ListBlobMetadataAsync(string uri);
        Task<IDictionary<string, string>> ListContainerMetadataAsync();
        Task<bool> AddContainerMetadataAsync(List<KeyValuePair<string, string>> metadata);
        Task<bool> AddBlobMetadataAsync(string uriStr, BlobMetaDataEntity metadata);
        Task<bool> SetBlobContentTypeAsync(string uri, string contentType);
    }
}
