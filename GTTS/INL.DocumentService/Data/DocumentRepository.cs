using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Diagnostics;
using Dapper;

using INL.DocumentService.Models;
using INL.Repositories;


namespace INL.DocumentService.Data
{
    public class DocumentRepository : IDocumentRepository
    {
        private readonly IDbConnection dbConnection;

		public IGenericRepository<FilesViewEntity, SaveFileEntity, long> FilesRepository =>
			new Lazy<IGenericRepository<FilesViewEntity, SaveFileEntity, long>>(() =>
			   new GenericRepository<FilesViewEntity, SaveFileEntity, long>(dbConnection, insertSProcName: "files.SaveFile", getAllSProcName: "files.GetFiles", getByIdSProcName: "files.GetFile", primaryKeyName: "FileID")
			).Value;

		public DocumentRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }

        public async Task<FilesViewEntity> GetFileByIDAndVersionAsync(long fileID, int? version)
        {
            return await FilesRepository.GetAsync("files.GetFile", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("FileID", fileID, DbType.Int64),
                new Tuple<string, object, DbType>("FileVersion", version, DbType.Int32)});
        }
    }
}
