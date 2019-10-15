using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using INL.ReferenceService.Models;
using Dapper;
using INL.Repositories;

namespace INL.ReferenceService.Data
{
    public interface IReferenceRepository
    {
        IGenericRepository<List<ReferenceTablesEntity>, GetReferenceTablesEntity, string> Repository { get; }

        List<IEnumerable<object>> GetTrainingReferences();
        List<ReferenceTablesEntity> GetReferences(string TablesJSON, int? CountryID, int? PostID);
    }
}
