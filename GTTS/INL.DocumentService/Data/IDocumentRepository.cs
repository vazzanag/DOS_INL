using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using INL.DocumentService.Models;
using INL.Repositories;

namespace INL.DocumentService.Data
{
    public interface IDocumentRepository
    {
        IGenericRepository<FilesViewEntity, SaveFileEntity, long> FilesRepository { get; }
        Task<FilesViewEntity> GetFileByIDAndVersionAsync(long fileID, int? version);
    }
    
}
