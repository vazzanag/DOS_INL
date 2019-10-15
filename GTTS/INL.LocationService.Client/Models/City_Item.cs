﻿namespace INL.LocationService.Client.Models
{
    public class City_Item
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
}
