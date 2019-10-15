using System.Threading.Tasks;
using INL.LocationService.Client.Models;

namespace INL.LocationService.Client
{
    public interface ILocationServiceClient
	{
		Task<IFetchLocationByAddress_Result> FetchLocationByAddress(IFetchLocationByAddress_Param fetchLocationParam);
        Task<IGetCitiesByStateID_Result> GetCitiesByStateID(int stateID);
        Task<FindCity_Result> FindCityByCityNameStateNameAndCountryName(FindCityByCityNameStateNameAndCountryName_Param param);
        Task<FindCity_Result> FindCityByCityNameStateNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param);
        Task<FindCity_Result> FindCityByCityNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param);
        Task<FindCity_Result> FindOrCreateCityByCityNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param);
    }
}
