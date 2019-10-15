using System;

namespace INL.SearchService.Models
{
    public interface ISearchTrainingEventLocations_Item
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
}
