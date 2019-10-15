using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using Dapper;
using INL.LocationService.Models;
using INL.Repositories;


namespace INL.LocationService.Data
{
    public class LocationRepository : ILocationRepository
    {
        private readonly IDbConnection dbConnection;

        public IGenericRepository<List<LocationsViewEntity>, GetLocationsByCountryID_Item, string> Repository =>
            new Lazy<IGenericRepository<List<LocationsViewEntity>, GetLocationsByCountryID_Item, string>>(() =>
               new GenericRepository<List<LocationsViewEntity>, GetLocationsByCountryID_Item, string>(dbConnection, insertSProcName: "", getAllSProcName: "", getByIdSProcName: "", primaryKeyName: "")
            ).Value;

        public LocationRepository(IDbConnection dbConnection)
		{
			this.dbConnection = dbConnection;
		}

		public List<IPostsViewEntity> GetPosts()
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<PostsViewEntity>(
				"location.GetPosts",
				commandType: CommandType.StoredProcedure).AsList<IPostsViewEntity>();


			return result;
		}

		public List<ICountriesViewEntity> GetCountries()
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<CountriesViewEntity>(
				"location.GetCountries",
				commandType: CommandType.StoredProcedure).AsList<ICountriesViewEntity>();
				

			return result;
		}

		public List<ILocationsViewEntity> GetLocationsByCountryID(int countryID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<LocationsViewEntity>(
                "location.GetLocationsByCountryID",
                param: new
                {
                    CountryID = countryID
                },
                commandType: CommandType.StoredProcedure).AsList<ILocationsViewEntity>();


            return result;
        }

        public List<ICitiesViewEntity> GetCitiesByCountryID(int countryID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<CitiesViewEntity>(
                "location.GetCitiesByCountryID",
                param: new
                {
                    CountryID = countryID
                },
                commandType: CommandType.StoredProcedure).AsList<ICitiesViewEntity>();


            return result;
        }

        public List<ICitiesViewEntity> GetCitiesByStateID(int stateID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<CitiesViewEntity>(
                "location.GetCitiesByStateID",
                param: new
                {
                    StateID = stateID
                },
                commandType: CommandType.StoredProcedure).AsList<ICitiesViewEntity>();


            return result;
        }

        public List<IStatesViewEntity> GetStatesByCountryID(int countryID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<StatesViewEntity>(
                "location.GetStatesByCountryID",
                param: new
                {
                    CountryID = countryID
                },
                commandType: CommandType.StoredProcedure).AsList<IStatesViewEntity>();


            return result;
        }

        public ILocationsViewEntity FetchLocationByAddress(IFindOrCreateLocationEntity entity)
        {
            var result = dbConnection.Query<LocationsViewEntity>(
                "location.FindOrCreateLocation",
                param: new
                {
                    CountryID = entity.CountryID,
                    StateID = entity.StateID,
                    CityID = entity.CityID,
                    Address1 = entity.Address1,
                    Address2 = entity.Address2,
                    Address3 = entity.Address3,
                    ModifiedByAppUserID = entity.ModifiedByAppUserID,
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public ICitiesViewEntity FindCityByCityNameStateNameAndCountryName(IFindCityByCityNameStateNameAndCountryNameEntity entity)
        {
            var result = dbConnection.Query<CitiesViewEntity>(
                "location.FindCityByCityNameStateNameAndCountryName",
                param: new
                {
                    entity.CityName,
                    entity.StateName,
                    entity.CountryName
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public ICitiesViewEntity FindOrCreateCityByCityNameStateNameAndCountryID(IFindOrCreateCityByCityNameStateNameAndCountryIDEntity entity)
        {
            var result = dbConnection.Query<CitiesViewEntity>(
                "location.FindOrCreateCityByCityNameStateNameAndCountryID",
                param: new
                {
                    entity.CityName,
                    entity.StateName,
                    entity.CountryID,
                    entity.ModifiedbyAppUserID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public ICitiesViewEntity FindCityByCityNameStateNameAndCountryID(IFindCityByCityNameStateNameAndCountryIDEntity entity)
        {
            var result = dbConnection.Query<CitiesViewEntity>(
                "location.FindCityByCityNameStateNameAndCountryID",
                param: new
                {
                    entity.CityName,
                    entity.StateName,
                    entity.CountryID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }
    }
}
