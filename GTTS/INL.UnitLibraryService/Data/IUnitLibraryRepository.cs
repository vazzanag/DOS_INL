using System.Collections.Generic;
using INL.Repositories;

namespace INL.UnitLibraryService.Data
{
    public interface IUnitLibraryRepository { 
    
        IGenericRepository<UnitsViewEntity, ISaveUnitEntity, long> UnitLibraryRepo { get; }

        List<UnitsViewEntity> GetAgenciesPaged(IGetUnitsPagedEntity param);
        List<UnitsViewEntity> GetUnitsPaged(IGetUnitsPagedEntity param);
        IUnitsViewEntity GetUnit(long UnitID);
        IUnitsViewEntity SaveUnit(ISaveUnitEntity param);
        IUnitsViewEntity UpdateUnitParent(IUpdateUnitParentEntity updateUnitParentEntity);
        IUnitsViewEntity UpdateUnitActiveFlag(IUpdateUnitActiveFlagEntity updateUnitActiveFlagEntity);
		UnitsViewEntity CheckForDuplicateUnit(string unitName, string unitNameEnglish, long? parentID, int countryID, string unitGenID);
        IUnitsViewEntity GetNextUnitGenID(int? countryID, long? mainagencyID);
        UnitsViewEntity FindUnitByNameAndCountryID(FindUnitByNameAndCountryIDEntity entity);
        List<UnitsViewEntity> GetUnitAndChildren(long? unitID);
        List<ReportingTypesViewEntity> GetReportingTypes();
    }
}
