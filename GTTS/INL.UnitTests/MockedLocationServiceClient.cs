using INL.LocationService.Client;
using INL.LocationService.Client.Models;
using System.Threading.Tasks;
using System.Collections.Generic;


namespace INL.UnitTests
{
	public class MockedLocationServiceClient : ILocationServiceClient
	{
		public Task<IFetchLocationByAddress_Result> FetchLocationByAddress(IFetchLocationByAddress_Param fetchLocationParam)
		{
			var result = new FetchLocationByAddress_Result
			{

				LocationID = 1,
				LocationName = "",
				IsActive = true,
				ModifiedByAppUserID = 1,
				ModifiedDate = System.DateTime.Now,
				AddressLine1 = fetchLocationParam.Address1,
				AddressLine2 = fetchLocationParam.Address2,
				AddressLine3 = fetchLocationParam.Address3,
				CityID = fetchLocationParam.CityID.Value,
				CityName = "City",
				StateID = 1,
				StateName = "State",
				CountryID = 1,
				CountryName = "Country"
			};


			return Task.FromResult<IFetchLocationByAddress_Result>(result);
		}

		public Task<IGetCitiesByStateID_Result> GetCitiesByStateID(int stateID) 
		{
			var result = new GetCitiesByStateID_Result()
			{
				Collection = new List<GetCitiesByStateID_Item>() 
				{
					new GetCitiesByStateID_Item()
					{
						CityID = 1,
						CityName = "City",
						StateID = stateID,
						StateName = "State",
						CountryID = 1,
						CountryName = "Country"
					}
				}
			};


			return Task.FromResult<IGetCitiesByStateID_Result>(result);
		}

		public Task<FindCity_Result> FindCityByCityNameStateNameAndCountryName(FindCityByCityNameStateNameAndCountryName_Param param)
		{
			var result = new FindCity_Result()
			{
				Item = new City_Item()
				{
					CityID = 1,
					CityName = param.CityName,
					StateID = 1,
					StateName = param.StateName,
					CountryID = 1,
					CountryName = param.CountryName
				}
			};


			return Task.FromResult(result);
		}

		public Task<FindCity_Result> FindCityByCityNameStateNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param)
		{
			var result = new FindCity_Result()
			{
				Item = new City_Item()
				{
					CityID = 1,
					CityName = param.CityName,
					StateID = 1,
					StateName = param.StateName,
					CountryID = 1,
					CountryName = "Country"
				}
			};


			return Task.FromResult(result);
		}

        public Task<FindCity_Result> FindCityByCityNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param)
        {
            var result = new FindCity_Result()
            {
                Item = new City_Item()
                {
                    CityID = 1,
                    CityName = param.CityName,
                    StateID = 1,
                    StateName = param.StateName,
                    CountryID = 1,
                    CountryName = "Country"
                }
            };


            return Task.FromResult(result);
        }


		public Task<FindCity_Result> FindOrCreateCityByCityNameAndCountryID(FindCityByCityNameStateNameAndCountryID_Param param)
		{
			var result = new FindCity_Result()
			{
				Item = new City_Item()
				{
					CityID = 1,
					CityName = param.CityName,
					StateID = 1,
					StateName = param.StateName,
					CountryID = 1,
					CountryName = "Country"
				}
			};

			return Task.FromResult(result);
		}


	}
}
