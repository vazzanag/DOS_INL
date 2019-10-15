using System.Threading.Tasks;
using INL.LocationService.Client;
using INL.PersonService.Client;

using INL.UnitLibraryService.Models;
namespace INL.UnitLibraryService
{
    public interface IUnitLibraryService
    {
		IUnit_Item CheckForDuplicateUnit(string unitName, string unitNameEnglish, long? parentID, int countryID, string unitGenID);
        GetUnitsPaged_Result GetAgenciesPaged(IGetUnitsPaged_Param param);
		GetUnit_Result GetUnit(long UnitID);
        GetUnitsPaged_Result GetUnitsPaged(IGetUnitsPaged_Param param);
		SaveUnit_Result SaveUnit(ISaveUnit_Param param, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient);
		IUpdateUnitActiveFlag_Result UpdateUnitActiveFlag(IUpdateUnitActiveFlag_Param param);
        UpdateUnitParent_Result UpdateUnitParent(IUpdateUnitParent_Param param);
        byte[] GeneratePDF(long unitID, string username);
        GetReportingTypes_Result GetReportingTypes();
		Task<ImportUnitLibrary_Result> ImportUnitLibrarySpreadsheet(int countryID, int modifiedByAppUserID, byte[] fileData, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient);
        GetUnitsPaged_Result GetChildUnits(long unitID);
    }
}
