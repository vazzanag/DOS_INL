using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
    public class FindOrCreateCityByCityNameStateNameAndCountryID_Param : IFindOrCreateCityByCityNameStateNameAndCountryID_Param
    {
        public string CityName { get; set; }
        public string StateName { get; set; }
        public long CountryID { get; set; }
        public int ModifiedbyAppUserID { get; set; }
    }
}
