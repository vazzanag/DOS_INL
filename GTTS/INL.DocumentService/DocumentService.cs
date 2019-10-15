using System;
using System.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using INL.DocumentService;
using INL.DocumentService.Data;
using INL.DocumentService.Models;
using System.Globalization;
using System.Diagnostics;
using INL.Services.Utilities;

namespace INL.DocumentService
{
    public class DocumentService : IDocumentService
    {
        private readonly IBlobRepository blobRepository = null;
		private readonly IDocumentRepository documentRepository = null;
		private readonly ILogger log = null;
        
        public DocumentService(IDocumentRepository documentRepository, IBlobRepository blobRepository = null, ILogger log = null)
		{
			this.documentRepository = documentRepository;
			this.blobRepository = blobRepository;
			if (log != null) this.log = log;
			else this.log = NullLogger.Instance;
		}


        public async Task<GetDocument_Result> GetDocumentAsync(GetDocument_Param getDocumentParam)
        {
            // Validate input
            ValidateGetDocument_Param(getDocumentParam);

            // Call document repo to obtain the uri and hash from Files table using getDocumentParam.FileID
            FilesViewEntity filesView = await documentRepository.GetFileByIDAndVersionAsync(getDocumentParam.FileID, getDocumentParam.FileVersion);

			if (filesView == null) return null;

			// Call blob repo to retrieve the document 
			var content = await blobRepository.GetBlobAsync(filesView.FileLocation);

            // Validate if the document has been tampered
            if (!VerifySHA256Hash(content, filesView.FileHash))
            {
                throw new ApplicationException($"The BLOB resource {filesView.FileName} has been tampered. Hash verification failed.");
            }

			// Convert to result
			var result = new GetDocument_Result()
			{
				FileID = filesView.FileID,
				FileName = filesView.FileName,
				FileHash = filesView.FileHash,
				FileSize = filesView.FileSize,
				ModifiedByAppUserID = filesView.ModifiedByAppUserID,
				FileContent = content
			};

            return result;
        }


        private void ValidateGetDocument_Param(GetDocument_Param getDocumentParam)
        {
            // Check for required data
            var missingData = new List<string>();
            if (getDocumentParam.FileID <= 0) missingData.Add("FileID");
            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "The require parameter is invalid.",
                    string.Join(", ", missingData)
                );
            }
		}


		public async Task<GetDocumentInfo_Result> GetDocumentInfoAsync(GetDocumentInfo_Param getDocumentInfoParam)
		{
			// Validate input
			ValidateGetDocumentInfo_Param(getDocumentInfoParam);

			// Call repo
			var filesView = await documentRepository.GetFileByIDAndVersionAsync(getDocumentInfoParam.FileID, getDocumentInfoParam.FileVersion);

			if (filesView == null) return null; 

			// Convert to result
			var result = new GetDocumentInfo_Result
			{
				FileID = filesView.FileID,
				FileName = filesView.FileName,
				FileSize = filesView.FileSize,
				FileHash = filesView.FileHash,
				ModifiedByAppUserID = filesView.ModifiedByAppUserID
			};

			return result;
		}


		private void ValidateGetDocumentInfo_Param(GetDocumentInfo_Param getDocumenInfoParam)
		{
			// Check for required data
			var missingData = new List<string>();
			if (getDocumenInfoParam.FileID <= 0) missingData.Add("FileID");
			if (missingData.Count > 0)
			{
				throw new ArgumentException(
					"The require parameter is invalid.",
					string.Join(", ", missingData)
				);
			}
		}


		public async Task<SaveDocument_Result> SaveDocumentAsync(SaveDocument_Param saveDocumentParam)
		{
			// Validate input
			ValidateSaveDocument_Param(saveDocumentParam);

			// Call blob repo to upload to a blob
			Uri uri = await blobRepository.SaveBlobAsync(saveDocumentParam.Context, saveDocumentParam.FileContent);

			// Generate Hash, and pass to Files table
			byte[] hash = GenerateSHA256Hash(saveDocumentParam.FileContent);

			// Call document repository to insert a record in the Files table
			SaveFileEntity saveFilesEntity = new SaveFileEntity
			{
				FileName = saveDocumentParam.FileName,
				FileLocation = uri.ToString(),
				FileID = saveDocumentParam.FileID,
				FileSize = saveDocumentParam.FileContent.Length,
				FileHash = hash,
				ModifiedByAppUserID = saveDocumentParam.ModifiedByAppUserID
			};

			FilesViewEntity filesView = documentRepository.FilesRepository.Save(saveFilesEntity);

			// Call blob repo to add blob metadata
			var blobMetaDataEntity = new BlobMetaDataEntity();
			blobMetaDataEntity.FileID = filesView.FileID;
			blobMetaDataEntity.FileVersion = filesView.FileVersion;
			blobMetaDataEntity.FileName = Utilities.ConvertDiacriticToASCII(filesView.FileName);
            blobMetaDataEntity.ModifiedByAppUserID = filesView.ModifiedByAppUserID;
			blobMetaDataEntity.FileSize = filesView.FileSize;
			blobMetaDataEntity.FileHash = filesView.FileHash;

            var result = new SaveDocument_Result();

            bool success = await blobRepository.AddBlobMetadataAsync(uri.ToString(), blobMetaDataEntity);
            result.FileID = filesView.FileID;
            result.FileVersion = filesView.FileVersion;

			return result;
		}

        private void ValidateSaveDocument_Param(SaveDocument_Param saveDocumentParam)
		{
			// Check for required data
			var missingData = new List<string>();
			if (String.IsNullOrWhiteSpace(saveDocumentParam.Context)) missingData.Add("Context");
			if (String.IsNullOrWhiteSpace(saveDocumentParam.FileName)) missingData.Add("FileName");
			if (saveDocumentParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
			if (saveDocumentParam.FileContent == null || saveDocumentParam.FileContent.Length <= 0) missingData.Add("FileContent");
			if (String.IsNullOrWhiteSpace(saveDocumentParam.FileName)) missingData.Add("missingData");

			if (missingData.Count > 0)
			{
				throw new ArgumentException(
					"Missing or Invalid required parameters.",
					string.Join(", ", missingData)
				);
			}
		}


		public async Task<DeleteDocument_Result> DeleteDocumentAsync(DeleteDocument_Param deleteDocumentParam)
        {
			throw new NotImplementedException();
        }


        private void ValidateDeleteDocument_Param(DeleteDocument_Param deleteDocumentParam)
        {
            // Check for required data
            var missingData = new List<string>();
            if (deleteDocumentParam.FileID <= 0) missingData.Add("FileID");
            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "The require parameter is invalid.",
                    string.Join(", ", missingData)
                );
            }
        }


        public static byte[] GenerateSHA256Hash(byte[] conent)
        {
            byte[] hash = null;

            // Initialize a SHA256 hash object.
            SHA256 mySHA256 = SHA256.Create();

            // Convert the input string to a byte array and compute the hash.
            return hash = mySHA256.ComputeHash(conent);
        }

		
        public static bool VerifySHA256Hash(byte[] conent, byte[] verifyHash)
        {
            // Hash the input
            byte[] hash = GenerateSHA256Hash(conent);
            
            if (hash.Length != verifyHash.Length) return false;

            // Decent speed
            for (int i = 0; i < hash.Length; i++)
            {
                if (hash[i] != verifyHash[i]) return false;
            }

            return true;
        }
    }
}
