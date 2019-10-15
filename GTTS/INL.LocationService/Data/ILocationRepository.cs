using System;
using System.Collections.Generic;
using System.Text;
using INL.Repositories;
using INL.LocationService.Models;

namespace INL.LocationService.Data
{
	public interface ILocationRepository
	{
        IGenericRepository<List<LocationsViewEntity>, GetLocationsByCountryID_Item, string> Repository { get; }

		List<IPostsViewEntity> GetPosts();
		List<ICountriesViewEntity> GetCountries();
		List<ILocationsViewEntity> GetLocationsByCountryID(int countryID);
		List<IStatesViewEntity> GetStatesByCountryID(int countryID);
		List<ICitiesViewEntity> GetCitiesByCountryID(int countryID);
		List<ICitiesViewEntity> GetCitiesByStateID(int stateID);
		ILocationsViewEntity FetchLocationByAddress(IFindOrCreateLocationEntity entity);
        ICitiesViewEntity FindCityByCityNameStateNameAndCountryName(IFindCityByCityNameStateNameAndCountryNameEntity entity);
        ICitiesViewEntity FindCityByCityNameStateNameAndCountryID(IFindCityByCityNameStateNameAndCountryIDEntity entity);
        ICitiesViewEntity FindOrCreateCityByCityNameStateNameAndCountryID(IFindOrCreateCityByCityNameStateNameAndCountryIDEntity entity);
    }
}
