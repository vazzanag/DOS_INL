using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Configuration;
using System.Diagnostics;
using Dapper;
using Newtonsoft.Json;
using INL.Repositories;

namespace INL.ReferenceService.Data
{
    public class ReferenceRepository : IReferenceRepository
    {
        private readonly IDbConnection dbConnection;

        public IGenericRepository<List<ReferenceTablesEntity>, GetReferenceTablesEntity, string> Repository =>
            new Lazy<IGenericRepository<List<ReferenceTablesEntity>, GetReferenceTablesEntity, string>>(() =>
               new GenericRepository<List<ReferenceTablesEntity>, GetReferenceTablesEntity, string>(dbConnection, insertSProcName: "", getAllSProcName: "", getByIdSProcName: "", primaryKeyName: "")
            ).Value;

        public ReferenceRepository(IDbConnection dbConnection)  
        {
            this.dbConnection = dbConnection;
		}

        public List<IEnumerable<object>> GetTrainingReferences()
        {
            List<IEnumerable<object>> ret = new List<IEnumerable<object>>();
            try
            {
                if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

                using (var tables = dbConnection.QueryMultiple("training.GetTrainingEventReferences"))
                {
                    ret.Add(tables.Read<TrainingEventTypesEntity>().ToList());
                    ret.Add(tables.Read<KeyActivitiesEntity>().ToList());
                    ret.Add(tables.Read<USPartnerAgenciesEntity>().ToList());
                    ret.Add(tables.Read<ProjectCodesEntity>().ToList());
                    ret.Add(tables.Read<BusinessUnitsEntity>().ToList());
                    ret.Add(tables.Read<CountriesEntity>().ToList());
                    ret.Add(tables.Read<StatesEntity>().ToList());
                    ret.Add(tables.Read<IAAsEntity>().ToList());
                    ret.Add(tables.Read<AppUsersEntity>().ToList());
                    ret.Add(tables.Read<VisaStatusesEntity>().ToList());
                }

            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.ToString());
            }
            finally
            {
                if (dbConnection.State != ConnectionState.Closed) dbConnection.Close();
            }
            return ret;
        }

        public List<ReferenceTablesEntity> GetReferences(string TablesJSON, int? CountryID, int? PostID)
        {
            return Repository.GetListFromMultiples<ReferenceTablesEntity>("dbo.GetReferenceTables", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("ReferenceList", TablesJSON, DbType.String),
                new Tuple<string, object, DbType>("CountryID", CountryID, DbType.String),
                new Tuple<string, object, DbType>("PostID", PostID, DbType.String)
            });
        }
    }
}
