using INL.DocumentService.Client;
using INL.DocumentService.Client.Models;
using INL.DocumentService.Data;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace INL.UnitTests
{
    /// <summary>
    /// Stores files in memory.
    /// </summary>
    public class MockedDocumentServiceClient : IDocumentServiceClient
    {
        private IDocumentRepository documentRepository;
        private Dictionary<long, Dictionary<int, MockedFile>> fileIdToFileVersions = new Dictionary<long, Dictionary<int, MockedFile>>();

        public MockedDocumentServiceClient(IDocumentRepository documentRepository)
        {
            this.documentRepository = documentRepository;
        }

        public Task<DeleteDocument_Result> DeleteDocumentAsync(DeleteDocument_Param deleteDocumentParam)
        {
            DeleteDocument_Result result = new DeleteDocument_Result();
            result.Success = fileIdToFileVersions.Remove(deleteDocumentParam.FileID);
            return Task.FromResult(result);
        }

        public Task<GetDocument_Result> GetDocumentAsync(GetDocument_Param getDocumentParam)
        {
            GetDocument_Result result = new GetDocument_Result();
            var fileVersions = this.fileIdToFileVersions[getDocumentParam.FileID];
            // If file version is not explicitly set as a parameter, just grab the last File Version entry from the dictionary
            MockedFile file = getDocumentParam.FileVersion != null ?
                fileVersions[getDocumentParam.FileVersion.Value] :
                fileVersions.Last().Value;
            result.FileID = file.FileID;
            result.FileContent = file.FileContent;
            result.FileHash = file.FileHash;
            result.FileName = file.FileName;
            result.FileSize = file.FileSize;
            result.ModifiedByAppUserID = file.ModifiedByAppUserID;
            return Task.FromResult(result);
        }

        public Task<GetDocumentInfo_Result> GetDocumentInfoAsync(GetDocumentInfo_Param getDocumentInfoParam)
        {
            var fileVersions = this.fileIdToFileVersions[getDocumentInfoParam.FileID];
            MockedFile file = getDocumentInfoParam.FileVersion != null ?
                fileVersions[getDocumentInfoParam.FileVersion.Value] :
                fileVersions.Last().Value;
            GetDocumentInfo_Result result = new GetDocumentInfo_Result();
            result.FileID = file.FileID;
            result.FileHash = file.FileHash;
            result.FileName = file.FileName;
            result.FileSize = file.FileSize;
            result.ModifiedByAppUserID = file.ModifiedByAppUserID;
            return Task.FromResult(result);
        }

        public Task<SaveDocument_Result> SaveDocumentAsync(SaveDocument_Param saveDocumentParam)
        {
            var filesViewEntity = this.documentRepository.FilesRepository.Save(new SaveFileEntity()
            {
                FileID = saveDocumentParam.FileID <= 0 ? (long?)null : saveDocumentParam.FileID,
                FileLocation = saveDocumentParam.FileName,
                ModifiedByAppUserID = saveDocumentParam.ModifiedByAppUserID,
                FileName = saveDocumentParam.FileName,
                FileHash = new byte[0],
                FileSize = 0
            });
            MockedFile file = new MockedFile();
            int fileVersion;
            if (saveDocumentParam.FileID <= 0) // File ID not explicitly passed. Create a new File Versions List entry in the dictionary
            {
                file.FileID = filesViewEntity.FileID;
                fileVersion = filesViewEntity.FileVersion;
                var fileVersions = new Dictionary<int, MockedFile>();
                fileVersions[fileVersion] = file;
                this.fileIdToFileVersions[file.FileID] = fileVersions;
            }
            else // File ID explicitly set. Grab the existing File Versions List entry and add a new File Version to it.
            {
                file.FileID = saveDocumentParam.FileID;
                var fileVersions = this.fileIdToFileVersions[saveDocumentParam.FileID];
                fileVersion = filesViewEntity.FileVersion;
                fileVersions[fileVersion] = file;
            }
            file.FileName = saveDocumentParam.FileName;
            file.FileContent = saveDocumentParam.FileContent;
            file.ModifiedByAppUserID = saveDocumentParam.ModifiedByAppUserID;
            SaveDocument_Result result = new SaveDocument_Result();
            result.FileID = file.FileID;
            result.FileVersion = fileVersion;
            return Task.FromResult(result);
        }

        public class MockedFile
        {
            public long FileID { get; set; }
            public string FileName { get; set; }
            public int FileSize { get; set; }
            public byte[] FileHash { get; set; }
            public byte[] FileContent { get; set; }
            public int ModifiedByAppUserID { get; set; }
        }
    }
}
