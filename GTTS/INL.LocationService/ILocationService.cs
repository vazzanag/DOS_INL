using INL.LocationService.Models;

namespace INL.LocationService
{
    public interface ILocationService
	{
		IGetCountries_Result GetCountries();
		IGetPosts_Result GetPosts();
		GetLocationsByCountryID_Result GetLocationsByCountryID(int countryID);
        GetStatesByCountryID_Result GetStatesByCountryID(int countryID);
        GetCitiesByStateID_Result GetCitiesByStateID(int stateID);
		GetCitiesByCountryID_Result GetCitiesByCountryID(int countryID);
		IFetchLocationByAddress_Result FetchLocationByAddress(IFetchLocationByAddress_Param param);
        FindCity_Result FindCityByCityNameStateNameAndCountryName(FindCityByCityNameStateNameAndCountryName_Param param);
        FindCity_Result FindCityByCityNameStateNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param);
        FindCity_Result FindOrCreateCityByCityNameStateNameAndCountryName(FindOrCreateCityByCityNameStateNameAndCountryID_Param param);
    }
}
