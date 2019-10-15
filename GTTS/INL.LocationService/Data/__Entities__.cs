 
  




using System;


namespace INL.LocationService.Data
{
  


	public interface ICitiesViewEntity
	{
	    int CityID { get; set; }
	    string CityName { get; set; }
	    int StateID { get; set; }
	    string StateName { get; set; }
	    string StateCodeA2 { get; set; }
	    string StateAbbreviation { get; set; }
	    string StateINKCode { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string GENCCodeA2 { get; set; }
	    string CountryAbbreviation { get; set; }
	    string CountryINKCode { get; set; }

	}

    public class CitiesViewEntity : ICitiesViewEntity
    {
		public int CityID { get; set; }
		public string CityName { get; set; }
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCodeA2 { get; set; }
		public string StateAbbreviation { get; set; }
		public string StateINKCode { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string CountryAbbreviation { get; set; }
		public string CountryINKCode { get; set; }

    }
      
	public interface ICountriesViewEntity
	{
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string GENCCodeA2 { get; set; }
	    string GENCCodeA3 { get; set; }
	    string INKCode { get; set; }

	}

    public class CountriesViewEntity : ICountriesViewEntity
    {
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string GENCCodeA3 { get; set; }
		public string INKCode { get; set; }

    }
      
	public interface ILocationsViewEntity
	{
	    long LocationID { get; set; }
	    string LocationName { get; set; }
	    bool IsActive { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string AddressLine1 { get; set; }
	    string AddressLine2 { get; set; }
	    string AddressLine3 { get; set; }
	    int CityID { get; set; }
	    string CityName { get; set; }
	    int StateID { get; set; }
	    string StateName { get; set; }
	    string StateCodeA2 { get; set; }
	    string StateAbbreviation { get; set; }
	    string StateINKCode { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string GENCCodeA2 { get; set; }
	    string CountryAbbreviation { get; set; }
	    string CountryINKCode { get; set; }
	    string Latitude { get; set; }
	    string Longitude { get; set; }

	}

    public class LocationsViewEntity : ILocationsViewEntity
    {
		public long LocationID { get; set; }
		public string LocationName { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string AddressLine1 { get; set; }
		public string AddressLine2 { get; set; }
		public string AddressLine3 { get; set; }
		public int CityID { get; set; }
		public string CityName { get; set; }
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCodeA2 { get; set; }
		public string StateAbbreviation { get; set; }
		public string StateINKCode { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string CountryAbbreviation { get; set; }
		public string CountryINKCode { get; set; }
		public string Latitude { get; set; }
		public string Longitude { get; set; }

    }
      
	public interface IPostsViewEntity
	{
	    int PostID { get; set; }
	    string PostName { get; set; }
	    int? GMTOffset { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    bool IsActive { get; set; }

	}

    public class PostsViewEntity : IPostsViewEntity
    {
		public int PostID { get; set; }
		public string PostName { get; set; }
		public int? GMTOffset { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public bool IsActive { get; set; }

    }
      
	public interface IStatesViewEntity
	{
	    int StateID { get; set; }
	    string StateName { get; set; }
	    string StateCodeA2 { get; set; }
	    string StateAbbreviation { get; set; }
	    string StateINKCode { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string GENCCodeA2 { get; set; }
	    string CountryAbbreviation { get; set; }
	    string CountryINKCode { get; set; }

	}

    public class StatesViewEntity : IStatesViewEntity
    {
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCodeA2 { get; set; }
		public string StateAbbreviation { get; set; }
		public string StateINKCode { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string CountryAbbreviation { get; set; }
		public string CountryINKCode { get; set; }

    }
      



	public interface IFindCityByCityNameStateNameAndCountryIDEntity
    {
        string CityName { get; set; }
        string StateName { get; set; }
        string CountryID { get; set; }

    }

    public class FindCityByCityNameStateNameAndCountryIDEntity : IFindCityByCityNameStateNameAndCountryIDEntity
    {
		public string CityName { get; set; }
		public string StateName { get; set; }
		public string CountryID { get; set; }

    }
      
	public interface IFindCityByCityNameStateNameAndCountryNameEntity
    {
        string CityName { get; set; }
        string StateName { get; set; }
        string CountryName { get; set; }

    }

    public class FindCityByCityNameStateNameAndCountryNameEntity : IFindCityByCityNameStateNameAndCountryNameEntity
    {
		public string CityName { get; set; }
		public string StateName { get; set; }
		public string CountryName { get; set; }

    }
      
	public interface IFindOrCreateCityByCityNameStateNameAndCountryIDEntity
    {
        string CityName { get; set; }
        string StateName { get; set; }
        string CountryID { get; set; }
        int? ModifiedbyAppUserID { get; set; }

    }

    public class FindOrCreateCityByCityNameStateNameAndCountryIDEntity : IFindOrCreateCityByCityNameStateNameAndCountryIDEntity
    {
		public string CityName { get; set; }
		public string StateName { get; set; }
		public string CountryID { get; set; }
		public int? ModifiedbyAppUserID { get; set; }

    }
      
	public interface IFindOrCreateLocationEntity
    {
        int? CountryID { get; set; }
        int? StateID { get; set; }
        int? CityID { get; set; }
        string Address1 { get; set; }
        string Address2 { get; set; }
        string Address3 { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class FindOrCreateLocationEntity : IFindOrCreateLocationEntity
    {
		public int? CountryID { get; set; }
		public int? StateID { get; set; }
		public int? CityID { get; set; }
		public string Address1 { get; set; }
		public string Address2 { get; set; }
		public string Address3 { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface IGetCitiesByCountryIDEntity
    {
        int? CountryID { get; set; }

    }

    public class GetCitiesByCountryIDEntity : IGetCitiesByCountryIDEntity
    {
		public int? CountryID { get; set; }

    }
      
	public interface IGetCitiesByStateIDEntity
    {
        int? StateID { get; set; }

    }

    public class GetCitiesByStateIDEntity : IGetCitiesByStateIDEntity
    {
		public int? StateID { get; set; }

    }
      
	public interface IGetCountriesEntity
    {

    }

    public class GetCountriesEntity : IGetCountriesEntity
    {

    }
      
	public interface IGetLocationsByCountryIDEntity
    {
        int? CountryID { get; set; }

    }

    public class GetLocationsByCountryIDEntity : IGetLocationsByCountryIDEntity
    {
		public int? CountryID { get; set; }

    }
      
	public interface IGetPostsEntity
    {

    }

    public class GetPostsEntity : IGetPostsEntity
    {

    }
      
	public interface IGetStatesByCountryIDEntity
    {
        int? CountryID { get; set; }

    }

    public class GetStatesByCountryIDEntity : IGetStatesByCountryIDEntity
    {
		public int? CountryID { get; set; }

    }
      

}



