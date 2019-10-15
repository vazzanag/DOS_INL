using INL.LocationService.Data;
using INL.LocationService.Models;
using Mapster;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using System.Collections.Generic;

namespace INL.LocationService
{
    public class LocationService : ILocationService
    {
        private readonly ILocationRepository locationRepository;
        private readonly ILogger log;

		public LocationService(ILocationRepository locationRepository, ILogger log = null)
		{
			this.locationRepository = locationRepository;
			if (log != null) this.log = log;
			else this.log = NullLogger.Instance;

			if (!AreMappingsConfigured)
			{
				ConfigureMappings();
			}
        }

		public IGetPosts_Result GetPosts()
		{
			// Call repo
			var posts = locationRepository.GetPosts();

			// Convert to result
			var result = new GetPosts_Result()
			{
				Collection = posts.Adapt<List<IPostsViewEntity>, List<Post_Item>>()
			};

			return result;
		}

		public IGetCountries_Result GetCountries()
		{
			// Call repo
			var countries = locationRepository.GetCountries();

			// Convert to result
			var result = new GetCountries_Result()
			{
				Collection = countries.Adapt<List<ICountriesViewEntity>, List<Country_Item>>()
			};

			return result;
		}

        public GetLocationsByCountryID_Result GetLocationsByCountryID(int countryID)
        {
            // Call repo
            var locations = locationRepository.GetLocationsByCountryID(countryID);

            // Convert to result
            var result = new GetLocationsByCountryID_Result()
            {
                Collection = locations.Adapt<List<ILocationsViewEntity>, List<GetLocationsByCountryID_Item>>()
            };

            return result;
        }

        public GetCitiesByCountryID_Result GetCitiesByCountryID(int countryID)
        {
            // Call repo
            var cities = locationRepository.GetCitiesByCountryID(countryID);

            // Convert to result
            var result = new GetCitiesByCountryID_Result()
            {
                Collection = cities.Adapt<List<ICitiesViewEntity>, List<GetCitiesByCountryID_Item>>()
            };

            return result;
        }

        public GetStatesByCountryID_Result GetStatesByCountryID(int countryID)
        {
            // Call repo
            var states = locationRepository.GetStatesByCountryID(countryID);

            // Convert to result
            var result = new GetStatesByCountryID_Result()
            {
                Collection = states.Adapt<List<IStatesViewEntity>, List<GetStatesByCountryID_Item>>()
            };

            return result;
        }

        public GetCitiesByStateID_Result GetCitiesByStateID(int stateID)
        {
            // Call repo
            var cities = locationRepository.GetCitiesByStateID(stateID);

            // Convert to result
            var result = new GetCitiesByStateID_Result()
            {
                Collection = cities.Adapt<List<ICitiesViewEntity>, List<GetCitiesByStateID_Item>>()
            };

            return result;
        }

        public IFetchLocationByAddress_Result FetchLocationByAddress(IFetchLocationByAddress_Param param)
        {
            // Convert to repo input
            var fetchLocationEntity = param.Adapt<IFetchLocationByAddress_Param, IFindOrCreateLocationEntity>();

            // Call repo
            var location = locationRepository.FetchLocationByAddress(fetchLocationEntity);

            // Convert to result
            var result = location.Adapt<ILocationsViewEntity, FetchLocationByAddress_Result>();

            return result;
        }

        public FindCity_Result FindCityByCityNameStateNameAndCountryName(FindCityByCityNameStateNameAndCountryName_Param param)
        {
            // Convert to repo input
            var entity = param.Adapt<FindCityByCityNameStateNameAndCountryName_Param, FindCityByCityNameStateNameAndCountryNameEntity>();

            // Call repo
            var repoResult = locationRepository.FindCityByCityNameStateNameAndCountryName(entity);

            // Convert to result
            var result = repoResult?.Adapt<ICitiesViewEntity, City_Item>();

            return new FindCity_Result() { Item = result };
        }

        public FindCity_Result FindOrCreateCityByCityNameStateNameAndCountryName(FindOrCreateCityByCityNameStateNameAndCountryID_Param param)
        {
            // Convert to repo input
            var entity = param.Adapt<FindOrCreateCityByCityNameStateNameAndCountryID_Param, FindOrCreateCityByCityNameStateNameAndCountryIDEntity>();

            // Call repo
            var repoResult = locationRepository.FindOrCreateCityByCityNameStateNameAndCountryID(entity);

            // Convert to result
            var result = repoResult?.Adapt<ICitiesViewEntity, City_Item>();

            return new FindCity_Result() { Item = result };
        }

        public FindCity_Result FindCityByCityNameStateNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param)
        {
            // Convert to repo input
            var entity = param.Adapt<FindCityByCityNameStateNameAndCountryID_Param, FindCityByCityNameStateNameAndCountryIDEntity>();

            // Call repo
            var repoResult = locationRepository.FindCityByCityNameStateNameAndCountryID(entity);

            // Convert to result
            var result = repoResult?.Adapt<ICitiesViewEntity, City_Item>();

            return new FindCity_Result() { Item = result };
        }

        #region ### Mapster Config
        private static bool AreMappingsConfigured { get; set; }
        private static object MappingConfigurationLock = new { };
        private static void ConfigureMappings()
        {
            lock (MappingConfigurationLock)
            {
                TypeAdapterConfig<IFetchLocationByAddress_Param, IFindOrCreateLocationEntity>
                    .ForType()
                    .ConstructUsing(s => new FindOrCreateLocationEntity());

                TypeAdapterConfig<ILocationsViewEntity, FetchLocationByAddress_Result>
                    .ForType()
                    .ConstructUsing(s => new FetchLocationByAddress_Result());

                TypeAdapterConfig<IFindOrCreateCityByCityNameStateNameAndCountryID_Param, IFindOrCreateCityByCityNameStateNameAndCountryIDEntity>
                    .ForType()
                    .ConstructUsing(s => new FindOrCreateCityByCityNameStateNameAndCountryIDEntity());

                AreMappingsConfigured = true;
            }

        }
        #endregion
    }
}
