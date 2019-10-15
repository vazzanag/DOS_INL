using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
    public interface IFindOrCreateCityByCityNameStateNameAndCountryID_Param
    {
        string CityName { get; set; }
        string StateName { get; set; }
        long CountryID { get; set; }
        int ModifiedbyAppUserID { get; set; }
    }
}
