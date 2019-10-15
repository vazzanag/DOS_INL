using Dapper;
using INL.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace INL.UnitLibraryService.Data
{
    public class UnitLibraryRepository : IUnitLibraryRepository
    {
        private readonly IDbConnection dbConnection;

        public IGenericRepository<UnitsViewEntity, ISaveUnitEntity, long> UnitLibraryRepo =>
           new Lazy<IGenericRepository<UnitsViewEntity, ISaveUnitEntity, long>>(() =>
              new GenericRepository<UnitsViewEntity, ISaveUnitEntity, long>(dbConnection, insertSProcName: "unitlibrary.SaveUnit", getAllSProcName: string.Empty, getByIdSProcName: "unitlibrary.GetUnit", primaryKeyName: "UnitID")
           ).Value;

        public UnitLibraryRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }

        public List<UnitsViewEntity> GetAgenciesPaged(IGetUnitsPagedEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<UnitsViewEntity>(
                "unitlibrary.GetUnitsPaged",
                param: new
                {
                    PageSize = param.PageSize,
                    PageNumber = param.PageNumber,
                    SortDirection = param.SortDirection,
                    SortColumn = param.SortColumn,
                    CountryID = param.CountryID,
                    IsMainAgency = 1,
                    IsActive = param.IsActive
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<ReportingTypesViewEntity> GetReportingTypes()
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<ReportingTypesViewEntity>(
                "unitlibrary.GetReportingTypes",
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<UnitsViewEntity> GetUnitsPaged(IGetUnitsPagedEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();


            var result = dbConnection.Query<UnitsViewEntity>(
                "unitlibrary.GetUnitsPaged",
                param: new
                {
                    PageSize = param.PageSize,
                    PageNumber = param.PageNumber,
                    SortDirection = param.SortDirection,
                    SortColumn = param.SortColumn,
                    CountryID = param.CountryID,
                    IsMainAgency = param.IsMainAgency,
                    UnitMainAgencyID = param.UnitMainAgencyID,
                    IsActive = param.IsActive
                },
                commandTimeout:0, // Give more time, instead the query can throw The wait operation timed out
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public IUnitsViewEntity GetUnit(long UnitID)
        {
            var result = UnitLibraryRepo.GetById(UnitID);
            return result;
        }

        public IUnitsViewEntity SaveUnit(ISaveUnitEntity param)
        {
            var result = UnitLibraryRepo.Save(param);

            return result;
        }

        public IUnitsViewEntity UpdateUnitParent(IUpdateUnitParentEntity updateUnitParentEntity)
        {
            return UnitLibraryRepo.Update("unitlibrary.UpdateUnitParent", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("@UnitID",updateUnitParentEntity.UnitID.Value, DbType.Int64),
                new Tuple<string, object, DbType>("@UnitParentID",updateUnitParentEntity.UnitParentID.Value, DbType.Int64)
            });
        }

        public IUnitsViewEntity UpdateUnitActiveFlag(IUpdateUnitActiveFlagEntity updateUnitActiveFlagEntity)
        {
            return UnitLibraryRepo.Update("unitlibrary.UpdateUnitActiveFlag", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("@UnitID",updateUnitActiveFlagEntity.UnitID.Value, DbType.Int64),
                new Tuple<string, object, DbType>("@IsActive",updateUnitActiveFlagEntity.IsActive.Value, DbType.Byte)
            });
        }

        public UnitsViewEntity CheckForDuplicateUnit(string unitName, string unitNameEnglish, long? parentID, int countryID, string unitGenID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<UnitsViewEntity>(
				"unitlibrary.CheckForDuplicateUnit",
                param: new
                {
                    UnitNameLocalLanguage = unitName,
                    UnitNameEnglish = unitNameEnglish,
                    ParentID = parentID,
                    CountryID = countryID,
                    UnitGenID = unitGenID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public IUnitsViewEntity GetNextUnitGenID(int? countryID, long? mainagencyID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<UnitsViewEntity>(
                "unitlibrary.GetNextUnitGenID",
                param: new
                {
                    CountryID = countryID,
                    Identifier = string.Empty,
                    IncludeCountryCode = false,
                    UnitParentID = mainagencyID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public UnitsViewEntity FindUnitByNameAndCountryID(FindUnitByNameAndCountryIDEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<UnitsViewEntity>(
                "unitlibrary.FindUnitByNameAndCountryID",
                entity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public List<UnitsViewEntity> GetUnitAndChildren(long? unitID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<UnitsViewEntity>(
                "unitlibrary.GetUnitAndChildren",
                param: new
                {
                    UnitID = unitID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }
    }
}
